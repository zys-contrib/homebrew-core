class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.97.3.tar.gz"
  sha256 "0ac51f25d1f7a6042992a3e9ecd9a346aac0819913ef7a30ad920afb001b4234"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dc440b20d01350679bc781f49b56e084826c14e63bdff0a38e5b252245bde81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dc440b20d01350679bc781f49b56e084826c14e63bdff0a38e5b252245bde81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dc440b20d01350679bc781f49b56e084826c14e63bdff0a38e5b252245bde81"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b869df0cc60224a6c2f0ab9d9ca5290bfdb1764de300ea3e17d3f4fac69baaa"
    sha256 cellar: :any_skip_relocation, ventura:       "1a0bc1bbc201f11c4561b572d317cce5bd2ffd275e19047cf7f67781a4b9fcb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2c39c5ae5bcb15399118463fe434c99d5a0b62f52c848b629819c1a6ff3867a"
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
