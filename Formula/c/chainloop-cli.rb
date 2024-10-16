class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.96.21.tar.gz"
  sha256 "8915acf082c74fc9c6db80b1e92468a8eb20dbbfc86c6945d25f01b1be33d886"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "841aaebbd404ff3b6982ad7f059444ff35a1589da99585431978d454fc86b856"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "841aaebbd404ff3b6982ad7f059444ff35a1589da99585431978d454fc86b856"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "841aaebbd404ff3b6982ad7f059444ff35a1589da99585431978d454fc86b856"
    sha256 cellar: :any_skip_relocation, sonoma:        "04d6c0fdc206a24cbc747a3ea833d38d18176e4a16c1fe112a9cbd3d9af0ad70"
    sha256 cellar: :any_skip_relocation, ventura:       "50c595412934f365afc66065c1267fd36c76c9d001cea09762da7b2a4fff5479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d26027ff12208a00f499ccb9cd3fb4bf16495d9952c9ca4c127b3c7262ba736"
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
