class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.530.tar.gz"
  sha256 "60f4f0589ac0b6f9c3987d66f7fd3627d911e507cec4c59d9cbb05df9f7bf5fb"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5e0f24fe14c7cca825bfd4db8c6fd935257520e2a62ea4b29595e191c76b30b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d401cee53a18772405c58765ada8a649dcb85a82fb9748222ccba4a19256c848"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2200cbd90e1e3d5ecfee145ec549e6707b1c83ec2b888717e685561e699310bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b07aab936d2c951aab04239c6210ed85771dad87f518a0b4bf3391f4e8507c4"
    sha256 cellar: :any_skip_relocation, ventura:        "21afc41fb4bc4c63c7206e87837629cdcddaa41e39d656bc1f014006f2189d6e"
    sha256 cellar: :any_skip_relocation, monterey:       "9b72876eb54e2c3176560d1379fcfaf15c4175f92515cec473268e1239a3048b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ace89170cbbbdb5585865bf336059b4fc9fe96159d9fe1b88d3bbee710ed34"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
