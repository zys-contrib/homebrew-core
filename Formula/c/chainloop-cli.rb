class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.164.0.tar.gz"
  sha256 "ec1867217c3504abaf83c7f264b326baa8d6a5e2bd637d2039ce00d7b60eac37"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7a082b7c905b6fda2478869e3c068337615f781e2b06ce0778b7d2bfbe78cb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7a082b7c905b6fda2478869e3c068337615f781e2b06ce0778b7d2bfbe78cb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7a082b7c905b6fda2478869e3c068337615f781e2b06ce0778b7d2bfbe78cb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3677cdd8688119a50b9564c0778735097a26e607b79878ee1275d3ddaeea1cd7"
    sha256 cellar: :any_skip_relocation, ventura:       "d11e06ea606b9701e6a68d4a98b5597a045aafa68e5a08b9e83309871e6f5645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "268e0385b83654cddfc4928eab3adeeac6155d4b1c3d7e9a071186e1deb7907f"
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
