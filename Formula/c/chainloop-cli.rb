class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.118.0.tar.gz"
  sha256 "667664b7bc4469ae11dad74d2dd6651703d0c14c4f8516597d3589ad7c02df8c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3118669110145c540346bde40190e64cf80b764c4d0372d601a2b9231019c4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3118669110145c540346bde40190e64cf80b764c4d0372d601a2b9231019c4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3118669110145c540346bde40190e64cf80b764c4d0372d601a2b9231019c4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fd0ed0cbbb4f1acd0a0dc30ae8e806eccc8252a58cd5cff1e5d169aaaaa7cca"
    sha256 cellar: :any_skip_relocation, ventura:       "41ebf5a474e82b9d609df0fddf3ebc29bfe2a49525fded9c474f82389db80049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cac398ee2f2ddc533ae4d523b59f6519be5331d06e308eae6649e420b1b007d"
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
