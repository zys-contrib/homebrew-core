class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "56555e4184f4e2dafdf6e84b221bbe87f0979405cbb8ef2f407ab62541f83f7b"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cbbb3f6eb3080eb78b18c971b8a05f33320ec58a120eaf7f03945da97b3315e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8a2417ff78522b163aa22be15abad8b975a011c913a5d1e75cdc9631344ddd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c563d77bbd24133bbface99ff813364fbc1f1e0522f62cc1ebae3978b525d70"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a0b006fbf02e316716e2fe8e80789e3a5c26da97e3327f52fe8bd81b3e32847"
    sha256 cellar: :any_skip_relocation, ventura:       "b0864a2215d9eb21a1e882636eb97b48436909e346f03d8fb1912bbd777a004f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8e8312ebe4b2cd97e3d144d64cbd2d4069628eff4a6f610b32e70977d535feb"
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
