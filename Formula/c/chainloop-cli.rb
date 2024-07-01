class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.93.1.tar.gz"
  sha256 "68ea6b30ef991f8e74a7aab726c59658176244afbb4cb10c860504af8cd3a140"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc7677492214badeed3760fe16c3af508f1efa97680ffea14e62bac7268fa198"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9067c030aa0987a12e22ad6de4eed8c5a010db63b5c05e2a4f1c3fe9e1990ab0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a693c2a30fc087f7d105572baee99621a62b30b81e337a30460d29664b063b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad91db0e45c195be7314811bf252e02f5c9ad3ac2d9642b963d8574525e86a7b"
    sha256 cellar: :any_skip_relocation, ventura:        "d46ea6cf6a65351bb24e5f56f0ffbf197ed9d434f80748aa9cd9a12c9b02d05d"
    sha256 cellar: :any_skip_relocation, monterey:       "a5a018fc5dad65ebb1d89fb7daec1d79bc19875e2358fd1c674d9a4d8ee2e27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b608124d4d9ef8ac1979f5d1af7a2395dc51ea542c9da6c76519c1290c2b849"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
