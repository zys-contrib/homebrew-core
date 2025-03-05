class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.36.7.tar.gz"
  sha256 "2e0dacac123defd2bdddb9b321faf2d37f45b288a9a326bc55cab8fc215b1b0e"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d67c6148500113ae633c673baf899b9b4fec4a1fc7f9cf8d7d6e559994d6547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d67c6148500113ae633c673baf899b9b4fec4a1fc7f9cf8d7d6e559994d6547"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d67c6148500113ae633c673baf899b9b4fec4a1fc7f9cf8d7d6e559994d6547"
    sha256 cellar: :any_skip_relocation, sonoma:        "e58920183776a190c00d529664296cb62ffbc45543e4ef07f165d549565892ec"
    sha256 cellar: :any_skip_relocation, ventura:       "e58920183776a190c00d529664296cb62ffbc45543e4ef07f165d549565892ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93faeb30fd1780884d6bdef81205b7d57169bbfc918d3db867fc39d4ecf229b2"
  end

  depends_on "go"

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
