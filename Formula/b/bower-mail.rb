class BowerMail < Formula
  desc "Curses terminal client for the Notmuch email system"
  homepage "https://github.com/wangp/bower"
  url "https://github.com/wangp/bower/archive/refs/tags/1.1.1.tar.gz"
  sha256 "4c041681332d355710aa2f2a935ea56fbb2ba8d614be81dee594c431a1d493d9"
  license "GPL-3.0-or-later"
  head "https://github.com/wangp/bower.git", branch: "master"

  depends_on "mercury" => :build
  depends_on "pandoc" => :build
  depends_on "gpgme"
  depends_on "ncurses"
  depends_on "notmuch"

  def install
    system "make"
    system "make", "man"
    bin.install "bower"
    man1.install "bower.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bower --version")

    assert_match "Error: could not locate database", shell_output(bin/"bower 2>&1", 1)
  end
end
