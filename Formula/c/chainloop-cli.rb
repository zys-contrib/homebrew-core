class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.92.1.tar.gz"
  sha256 "ff810a5da5b6700e2cb816dcce1cf7d157c571290414e14da447973ea3fde528"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d80ed9184cf8da69c0dc25eecf0f63486f13ec5d79d1cc7bfbdd0f33805db79d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "822d301670c8e35b176e57ba59dd4ac3181380bf250d9ec00a0e7a6413058aba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "552e82beb02811023a7437af43174879eb2bfeadec23d1622b559cd0c949f827"
    sha256 cellar: :any_skip_relocation, sonoma:         "709af3f7a19af30f7359fa9a9c78e8b5acb44149266692d8b7b4880604d1360b"
    sha256 cellar: :any_skip_relocation, ventura:        "365c708932354658a84b9690170dcc097aeec09ff49d91ef235b63f917c087a0"
    sha256 cellar: :any_skip_relocation, monterey:       "5e00e87427822234628569650f6ecdd275e38cf7878a7218d7f919d4a00d99da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "018714b683bbee0902e2b9c13318c1f17e1c0c504208d38e6f98c8c53e64a987"
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
