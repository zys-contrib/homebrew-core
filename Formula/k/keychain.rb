class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://github.com/funtoo/keychain/archive/refs/tags/2.9.4.tar.gz"
  sha256 "c233cbb676d72d07c5c7e65ec472a55eae089e5bfa81e0b2714f9cb125835905"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db84c4a63443468017fffbcb174ba06dc3697c8a659722eb8ba112bb417b70fc"
  end

  def install
    system "make"
    bin.install "keychain"
    man1.install "keychain.1"
  end

  test do
    system bin/"keychain"
    hostname = shell_output("hostname").chomp
    assert_match "SSH_AGENT_PID", File.read(testpath/".keychain/#{hostname}-sh")
    system bin/"keychain", "--stop", "mine"
  end
end
