class Procps < Formula
  desc "Utilities for browsing procfs"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps/-/archive/v4.0.5/procps-v4.0.5.tar.gz"
  sha256 "2c6d7ed9f2acde1d4dd4602c6172fe56eff86953fe8639bd633dbd22cc18f5db"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/procps-ng/procps.git", branch: "master"

  bottle do
    rebuild 1
    sha256 x86_64_linux: "79434886665c5ef94464c83bf595cba0c449be107fcc70f05ec249d96814a1a7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on :linux
  depends_on "ncurses"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"

    # kill and uptime are also provided by coreutils
    rm [bin/"kill", bin/"uptime", man1/"kill.1", man1/"uptime.1"]
  end

  test do
    system bin/"ps", "--version"
    assert_match "grep homebrew", shell_output("#{bin}/ps aux | grep homebrew")
  end
end
