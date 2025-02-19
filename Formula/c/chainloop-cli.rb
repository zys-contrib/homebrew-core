class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.167.0.tar.gz"
  sha256 "ed869bb84f0dfecb02eb5c46d3331ffd8e7f274951d6f131d795e07883125317"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfddcaa1eb7cb61c547c3a401f11261d0a788f8db087058b287526488f75cad9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfddcaa1eb7cb61c547c3a401f11261d0a788f8db087058b287526488f75cad9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfddcaa1eb7cb61c547c3a401f11261d0a788f8db087058b287526488f75cad9"
    sha256 cellar: :any_skip_relocation, sonoma:        "138211d5db2438b62c5605264640b54d581b40dad3c4b173a5ca402af120ac28"
    sha256 cellar: :any_skip_relocation, ventura:       "ea4d6ed12120eadb2fee254fed13ecdda7bf79cdb38476403f439f3f13ba964b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "414e94afea64aab23be290bdec672529f73e50db4990ac6ecbbf8b75c7d7f150"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
