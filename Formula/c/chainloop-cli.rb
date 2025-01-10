class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.151.0.tar.gz"
  sha256 "8b1b849f377dcd33921d0347657b3870bba9ef999159bbb1aa0daf1f8873b8a7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05b8fff0a7bd37f1e2d0c22baf7733c6f1f6bf530acddfa9ffbb1c21a6bb73d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05b8fff0a7bd37f1e2d0c22baf7733c6f1f6bf530acddfa9ffbb1c21a6bb73d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05b8fff0a7bd37f1e2d0c22baf7733c6f1f6bf530acddfa9ffbb1c21a6bb73d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae5220aaf1da6c03ae0f87ecb5337d02ae907f61b2799d6c82a13ee508d82e62"
    sha256 cellar: :any_skip_relocation, ventura:       "f2844dc5326e98836b96f3613f4d77d07301fe1c7278a45ea58c16ef536890eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba01c8913d93ac73f453e5b7bd2894d82b087fa5b26452ba53f39b762e9ccc24"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
