class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "e4ce3e4c0ddfb33f1785d5b6bd6906e3a4434b84331ce99ebcb6bcd6bf2c2a08"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b0808fce05d172d9b449a5e15b29e09cd7f37c587aa697e4853219f423b6c31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56970215de14177cccdd2f004cf3079f53199ba3eb198721a2f1f480ddff95cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8adaa5430080ac7886dda0274713a2b8ca57110b6c14930179610b97d660068"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d4dfc262da7b4e2f70022d1565a40fcd5d624c98f80da5b7cc38cb446a5397b"
    sha256 cellar: :any_skip_relocation, ventura:       "2148837fcda9a55f09ae1028d0e00e6eee7b74090abd527f54203047b73fe9c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ef5cff7221c062abb70a51cfdfb2fecfb234d6c058032c8da192028978a259f"
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
