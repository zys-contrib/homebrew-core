class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.98.1.tar.gz"
  sha256 "c040e5eb592b7e1561ab45ee5571767805bda8f1cd01388365ac13c71f25a6f0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6710faed4580fc469f2c94055ae5e41b9234b22640030152621b2dd0b5061033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6710faed4580fc469f2c94055ae5e41b9234b22640030152621b2dd0b5061033"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6710faed4580fc469f2c94055ae5e41b9234b22640030152621b2dd0b5061033"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2a2c4a6690f522e6f59aa06e37908380daa5107d17fab25999e032286ec7bac"
    sha256 cellar: :any_skip_relocation, ventura:       "e57b648c8cb524a7933ef895d5ef1fe69b30fcba98f582e9ae6bbbb81e01d9f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be93df6939dcbe755862164479b2189358df3e26d87d9bc06d3134170079211e"
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
