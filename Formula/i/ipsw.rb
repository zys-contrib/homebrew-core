class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.586.tar.gz"
  sha256 "754ac406fc1673ec56b722af8992bb392ea0a168f0409d6147a7680fa16be3d4"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb35df00a6707b5020e1a22ad7324bc255bd12f5d8201aca40994bcfbc930aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "715268fbcb7015075979ba95ba2cdc369c2bb6302390246c8a03a8d52e202237"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6e40e3bce25e76a0098d45960eb0e1ecad7bef1a21a0800503844baf64ea4b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d69b1590337b73060b965566eefc4d4bc158ebeabc97420d42ff5cd9651f5bf2"
    sha256 cellar: :any_skip_relocation, ventura:       "e64d1bebbc570d814f972363494158b05aaa2c465f354f46f3cca27bc7c08a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9903ac8075ea650460f4dce245bfb4242392551dea7488d37447adb7588a11d0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
