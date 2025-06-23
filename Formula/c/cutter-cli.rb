class CutterCli < Formula
  desc "Unit Testing Framework for C and C++"
  homepage "https://github.com/clear-code/cutter"
  url "https://osdn.mirror.constant.com/cutter/73761/cutter-1.2.8.tar.gz"
  sha256 "bd5fcd6486855e48d51f893a1526e3363f9b2a03bac9fc23c157001447bc2a23"
  license "LGPL-3.0-or-later"
  head "https://github.com/clear-code/cutter.git", branch: "master"

  livecheck do
    url "https://osdn.net/projects/cutter/releases/"
    regex(%r{value=["'][^"']*?/rel/cutter/v?(\d+(?:\.\d+)+)["']}i)
  end

  no_autobump! because: :requires_manual_review

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make", "install"
  end

  test do
    touch "1.txt"
    touch "2.txt"
    system bin/"cut-diff", "1.txt", "2.txt"
  end
end
