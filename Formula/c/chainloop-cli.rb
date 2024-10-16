class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.96.20.tar.gz"
  sha256 "39a6a97400c01aad9ef1576447cf8f4f60a4441a1c2509ef6fce935530071455"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "297ab292ff166e99d63a525c1a86899212fa43c4b1d3006df1b70ce514947d02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "297ab292ff166e99d63a525c1a86899212fa43c4b1d3006df1b70ce514947d02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "297ab292ff166e99d63a525c1a86899212fa43c4b1d3006df1b70ce514947d02"
    sha256 cellar: :any_skip_relocation, sonoma:        "31ad1bd006a17f786a97ed84723f3d1f5f612f8e7d4feaadfc2702ab6426551b"
    sha256 cellar: :any_skip_relocation, ventura:       "4255b7dbb310e4e56f5a0bef6dd6394d6cc36b6e94cfe61524cdb19028cc7e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39a5ce4a6f8a90f4d4599949ece5c190cd08d14df5e17ab650649e79b992e6fc"
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
