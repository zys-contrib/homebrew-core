class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.184.0.tar.gz"
  sha256 "78899c0d0f7921cf6e7d3634def70bde56df5377a8f82ac59afd964f11c729e4"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dace7a69d37bcb98c063e57a2835cd40ffb73a399f11a8711f31807a53d0b0d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dace7a69d37bcb98c063e57a2835cd40ffb73a399f11a8711f31807a53d0b0d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dace7a69d37bcb98c063e57a2835cd40ffb73a399f11a8711f31807a53d0b0d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "559586bd7aa01fc56bbf88c683641f0fe741d50be9ec9fd375f3147e5e1f97d7"
    sha256 cellar: :any_skip_relocation, ventura:       "81d1c342480224ae756ca0037cca0c0f3e863dcbdf5726f2168d571cd3658bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "431fbdd76a82af601c5ccc5dd5cd6e8c8854310f9a21ea1874df9b3c250898bf"
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
