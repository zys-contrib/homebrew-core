class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.113.0.tar.gz"
  sha256 "2f562e8e6f8cd0150c6a2bf48f665ab028f7998616054721215b795562df70b0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63c4b23bb64d7f38e934e934e2e40bbb4432a18309bdf67a8074d4cce91ce13d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63c4b23bb64d7f38e934e934e2e40bbb4432a18309bdf67a8074d4cce91ce13d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63c4b23bb64d7f38e934e934e2e40bbb4432a18309bdf67a8074d4cce91ce13d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7864941395a1bf23005f57874959cb969655ae6358f4ad0fef9daaeeac93f40"
    sha256 cellar: :any_skip_relocation, ventura:       "2973aa211834a34f77ce2b26ca6750218946f27d09eeea7f9228c4a9b0bdbeeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6523ffb84ca509033c10b74870b3b6e1bed98c7a3b4a74581a457fbfc854f4d4"
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
