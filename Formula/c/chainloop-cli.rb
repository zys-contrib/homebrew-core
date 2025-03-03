class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.176.0.tar.gz"
  sha256 "17f41668de5b31d7ccf3a22f7fe022ded6ab7f03a058a2421799f5bab6d646c2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26d830ddf195242499237df9bd3b415bbdd860ebaaaeaffbd00479787a5deb8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26d830ddf195242499237df9bd3b415bbdd860ebaaaeaffbd00479787a5deb8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26d830ddf195242499237df9bd3b415bbdd860ebaaaeaffbd00479787a5deb8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "aea30d02e97e8a07174bb39ab7db77c5acb4aa9a16717d63921dc66b83cd93e2"
    sha256 cellar: :any_skip_relocation, ventura:       "50704caa2a1016dd8ff689db1a2bb530d9fa17924c6da092693f4bdec0e6a9dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27040754e8232524b21a1a4c1cc8bab35f70b4c12039d14ba0f4b85907c225e3"
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
