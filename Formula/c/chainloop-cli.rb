class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.92.6.tar.gz"
  sha256 "dddc73c0fdefddfd3f9acc5f74e547022c76293b0bddab8d241b7c32083899c5"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f8f4a8db3616248dfc2db6b185f56123ffd40ebb4016572be2c01be03ec74cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1621d7d427ad69d64faba8a9b57c1aac0035995341d7d5c164173127ac7bea78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "021d9cd64146ab6e97f634841f69e48225329b0c2a7a57c8f19a6701db984b34"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c4ac786602910476b65e8e4aa2b9c0f637df3fb603e3fcadafaa65949f5b898"
    sha256 cellar: :any_skip_relocation, ventura:        "5be51bcb0efba0acb5741b37933f628eac60cc3a00b2520792a18c044a81deaa"
    sha256 cellar: :any_skip_relocation, monterey:       "caa11ffa7ec7ac5246af465c9089acf76637aff8f6ba994a0ab5c785061a0e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc7fe3f12cbf9cbb0bdc82395eb74ec51e99ba81b6c98aee36546795d1f58dc2"
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
