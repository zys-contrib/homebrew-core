class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.120.0.tar.gz"
  sha256 "02acd34b8c8332accb2965bf1669e16adfaf62c93fc71563fa068c40011b0998"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58f3c2cf861fa83b81f81105b1b3d403dadb56c4ecc86bde4bd4555ba3e14b93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58f3c2cf861fa83b81f81105b1b3d403dadb56c4ecc86bde4bd4555ba3e14b93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58f3c2cf861fa83b81f81105b1b3d403dadb56c4ecc86bde4bd4555ba3e14b93"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6ee547d8ddfd0f3f46f4208d4e69b04d8818201b135a57276e000ae985bbf8e"
    sha256 cellar: :any_skip_relocation, ventura:       "303b3f6001b8a82f6e5d517d48151fa01c46ec1ea0980ae4eff0acb3cc97f641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490923ed5ded6436fe64366b93728c8b5a780da82c88041a09a1de55622e3b64"
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
