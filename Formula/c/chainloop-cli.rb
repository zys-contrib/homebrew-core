class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "f4c188598f55e57a7be386f242ed55819e486cacaf09566e11b66eeac646e3f5"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "266aec8b00e3f8cb1f208505ed043e65e1845f986c2294bc043804255cc87530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "222273e00e3c9b3a6ce646807b914b87d618fa40eaf207b977f8a7db5becbfc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "574c5d18d2da9766e416ba1a2c45705b0f597a1a0412ee833914b3d0f3f34f53"
    sha256 cellar: :any_skip_relocation, sonoma:        "e80fe668c540fc18ecb94e6e770e038b3fc1604ca75617623cd4c0d08ad057dc"
    sha256 cellar: :any_skip_relocation, ventura:       "23f369cb4a14a403f4d75252ee1f2c269a67225c5731da51a0b08f9e16ebecc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c2757b413898af5f44f4b9c2702c08053689eff02b58dc0dfe8ef2bc12754d"
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
