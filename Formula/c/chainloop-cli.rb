class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.96.11.tar.gz"
  sha256 "44b24c2989b07915e3ece92c37f9d221305a0558095608e26c893dff84c8161e"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48870e36607a7ee038c21ba3bd2b107543b0b2586926d5754ad21adf13f367c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48870e36607a7ee038c21ba3bd2b107543b0b2586926d5754ad21adf13f367c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48870e36607a7ee038c21ba3bd2b107543b0b2586926d5754ad21adf13f367c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f61587df04ac85a37e9a348b7f6af1fef3fb8ca16ccdf33e0a9ae0a0f3af1808"
    sha256 cellar: :any_skip_relocation, ventura:       "34524100377eff8e2250bde9755d586984f150f6554b31fe3a7682a09aa02622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd8f378bccea139e36260a1dbc491f62f51aac6b2637c2d9c04b493ca0e49fd4"
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
