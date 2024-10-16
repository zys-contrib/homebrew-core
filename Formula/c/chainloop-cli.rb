class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.96.20.tar.gz"
  sha256 "39a6a97400c01aad9ef1576447cf8f4f60a4441a1c2509ef6fce935530071455"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebf6f5232572b062068f5188ec56f06556dd7fc70661b3c936295f405af3ac59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebf6f5232572b062068f5188ec56f06556dd7fc70661b3c936295f405af3ac59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebf6f5232572b062068f5188ec56f06556dd7fc70661b3c936295f405af3ac59"
    sha256 cellar: :any_skip_relocation, sonoma:        "65038834196ea53f28758eba6dbb93a829d3a44b62f97cec7238f62e9e8ac87a"
    sha256 cellar: :any_skip_relocation, ventura:       "068e1550986e78742da9892eaa39de5b0d352526a11f7df39e4d3efe227ff935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89a8614ab307e65307ee2abb29946fc350ddafca8b17750c8654d8ea35cf4771"
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
