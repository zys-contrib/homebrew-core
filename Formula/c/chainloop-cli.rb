class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.122.0.tar.gz"
  sha256 "f6744f950a2b60233eb993272bdad80f88ba6ab86a6e60cef8459cdbe0e7ce19"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55c5b93e16bde8c6d555d74c0dbcc54a73c00cf214c282b7e0813058e5f5401d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55c5b93e16bde8c6d555d74c0dbcc54a73c00cf214c282b7e0813058e5f5401d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55c5b93e16bde8c6d555d74c0dbcc54a73c00cf214c282b7e0813058e5f5401d"
    sha256 cellar: :any_skip_relocation, sonoma:        "485e665023b23d1c80bd41a7a65849be4bdf892d35f6bedaaf8244dce605fab9"
    sha256 cellar: :any_skip_relocation, ventura:       "dffa2dcfa111f045cd202f7e04289d30e589b6fab7be95b225d43a34ea525b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4241cc6424e7c10a3c8b02a64d03e3e867c869972708d686b01dd42c2b6964f"
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
