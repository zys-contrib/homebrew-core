class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.171.0.tar.gz"
  sha256 "59ac644c18729e99e641991d7ebd3c2a17bd49e8af1df2b6faef3263d72c51c7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cd3c3bf6c54bcbae41e4ae46e66ee1f3c4b23888275b80b034b822d0e41157a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cd3c3bf6c54bcbae41e4ae46e66ee1f3c4b23888275b80b034b822d0e41157a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cd3c3bf6c54bcbae41e4ae46e66ee1f3c4b23888275b80b034b822d0e41157a"
    sha256 cellar: :any_skip_relocation, sonoma:        "80154b339636dc01cfc6649eaf2a97929d05525b4172a3601a146ab75947d98d"
    sha256 cellar: :any_skip_relocation, ventura:       "17bc0c694a63bfcf262bf4868b16287fddd6f7024be5e62b8a2131c4ba00cfab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da2217b43264fcae8ac128d52608392d0f9cf4509fc88149f29157cadf766687"
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
