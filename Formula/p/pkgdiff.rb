class Pkgdiff < Formula
  desc "Tool for analyzing changes in software packages (e.g. RPM, DEB, TAR.GZ)"
  homepage "https://lvc.github.io/pkgdiff/"
  url "https://github.com/lvc/pkgdiff/archive/refs/tags/1.8.tar.gz"
  sha256 "4b44a933a776500937887134cf89b94a89199304c416ad05b2ac365cce1076d8"
  license "GPL-2.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "1c25de8323bd487af7aeb730739a6bfcae9aba334da7ef20a0166b56c705341e"
  end

  depends_on "binutils"
  depends_on "gawk"
  depends_on "wdiff"

  def install
    system "perl", "Makefile.pl", "--install", "--prefix=#{prefix}"
  end

  test do
    system bin/"pkgdiff"
  end
end
