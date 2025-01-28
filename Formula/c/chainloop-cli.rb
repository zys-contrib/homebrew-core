class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.155.0.tar.gz"
  sha256 "31ee00cd47b603786094dc1af6252580a07a4ac4aeff6ce7f6e8a6d25402d59c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3b1e48ffbcce9b3d2dc97b958f6b34e6c38a9776c955f54329c5bdbcaf679bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3b1e48ffbcce9b3d2dc97b958f6b34e6c38a9776c955f54329c5bdbcaf679bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3b1e48ffbcce9b3d2dc97b958f6b34e6c38a9776c955f54329c5bdbcaf679bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f37db8e96b654cd296abd78e8889f52f076c4df4286582c22437390d03738378"
    sha256 cellar: :any_skip_relocation, ventura:       "55c12455ffab1972e1cb49c7f5076dc0eb1e394c26289d5bb01f0958a5e83d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffd60310a7680b07c1c19e2fee4bea1c1e879981a65b138970c279dcadf14831"
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
