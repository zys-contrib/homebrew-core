class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://github.com/funtoo/keychain/archive/refs/tags/2.9.0.tar.gz"
  sha256 "834e02ba99c20e93aaceba0ec510bd16f2cc0e6e1af56c039d3e57128b52b5ad"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a042cd95caaaa27f769687a242b244213ff4af6ec93194e03fc1014a2fca2175"
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
