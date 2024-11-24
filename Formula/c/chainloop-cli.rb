class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.125.0.tar.gz"
  sha256 "50ec3ed503e0719e8dd92ff24d3259e86b3306efe8fd9c6fa9ba59eda7faf7fa"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90a15dc4542592a0df727f2e646b0959755b912cc3cff0643ecacf086302867a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90a15dc4542592a0df727f2e646b0959755b912cc3cff0643ecacf086302867a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90a15dc4542592a0df727f2e646b0959755b912cc3cff0643ecacf086302867a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b7afe8291d5757b641a6615f2540756b6bc7ddac0e2bbe5e9fcef800def9574"
    sha256 cellar: :any_skip_relocation, ventura:       "73e1cd3c8c6c587e219983dcf951de2d3d5aa5b74b514cc17b78778e1fc344b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c9431d1910df68aa029619e7f5d7ed3989035a2f15070531543eb62b3a6aa51"
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
