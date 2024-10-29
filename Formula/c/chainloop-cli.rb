class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.97.6.tar.gz"
  sha256 "fab9062352ef235fa72b3f0f653425eb73146e48e0e378ff468e5207fbd52d66"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70d3b74ad1c5263f682ccd2529d8dca24acabe8cb98ac88f4db91626183851f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70d3b74ad1c5263f682ccd2529d8dca24acabe8cb98ac88f4db91626183851f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70d3b74ad1c5263f682ccd2529d8dca24acabe8cb98ac88f4db91626183851f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5e372944841732aa944d8c03354c8745814f5df0993e127618c9c28757f615a"
    sha256 cellar: :any_skip_relocation, ventura:       "586db8e78906a84b49b51f92ecd87fa84d7ed9c96bef1c4686cd0ad3cf1afd62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e4f12586e21a6382ddab43daf2f65a11a5a14e023364f657ca7199a0f7e3697"
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
