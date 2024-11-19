class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.110.0.tar.gz"
  sha256 "c8c3dbc1c6e9d64b7b9e202e65f45eb73e5f3815da635fca8c1e33366a3f52d6"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d09bf623f143854108dcc2db2b54f32f7cb89122c4196434faf4da7821623261"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d09bf623f143854108dcc2db2b54f32f7cb89122c4196434faf4da7821623261"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d09bf623f143854108dcc2db2b54f32f7cb89122c4196434faf4da7821623261"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b3da52ad3a06371aff57823498688954eb79c5ea3ada30fc79648805f51da0b"
    sha256 cellar: :any_skip_relocation, ventura:       "f1787cdab960542c572fe4c759aacdc4756c7fd181e4c22e151f6f7cca7117b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "442fa208962008ef59cf6be474a7f6af5e6655f15043420005f588b6c952b9ce"
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
