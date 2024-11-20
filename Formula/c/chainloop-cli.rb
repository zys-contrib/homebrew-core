class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.116.0.tar.gz"
  sha256 "53af5c3f54afb88f2412a3085bc0ff4455cedb474aa1d60a8e133274d77f90f8"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d240678ae10adc66263f5b3e1537a2dfcc39efaa54e8c1ae1dbd5eb7cb914c23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d240678ae10adc66263f5b3e1537a2dfcc39efaa54e8c1ae1dbd5eb7cb914c23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d240678ae10adc66263f5b3e1537a2dfcc39efaa54e8c1ae1dbd5eb7cb914c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "f36b719b3ba3a2a6fbe6b044e12ad68c16e860a11e855cf70183aa819fadd59a"
    sha256 cellar: :any_skip_relocation, ventura:       "9b6c53e48599317a0015e762e0dac6f3aa48bb63575e0029e4871bb1c7b54c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7662d2cad1d09efe0a745be0eac25e32f6548b7c00cebb655e18a94845f91b0e"
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
