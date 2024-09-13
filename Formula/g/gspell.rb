class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.14/gspell-1.14.0.tar.xz"
  sha256 "64ea1d8e9edc1c25b45a920e80daf67559d1866ffcd7f8432fecfea6d0fe8897"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia:  "7ef648e30d2a300ced7dfa60b6176ea4262bb270c03cd47f27efb7867f5a9cd4"
    sha256 arm64_sonoma:   "e3c60c553bc207bd79782ff8057f1a2a100ae83abdea680e07a80890d409de6f"
    sha256 arm64_ventura:  "176a3af6ec71a5fbe2dba3c9ab5f931e4946ebbd9786670aa2c5bce827065d95"
    sha256 arm64_monterey: "ad975f225b5ba1d0b103ec980f0ab083e3c48355e1cd95d3d9ec5924b29830ac"
    sha256 sonoma:         "c8e7040dbfa7da13e66c7741a55c9d815dfd8ef5f17ab43f5ddfab3d5845eaf1"
    sha256 ventura:        "c1cf683b898ebc84f913f2f44e83c8f8b89508e67acc691981901bbfee3df337"
    sha256 monterey:       "403f2159375a438c99743db41c1275e27ab0d6b26c8ee6171e344dff847c02fe"
    sha256 x86_64_linux:   "1e74d8a181bc1e6fc55d1eb36a737728077969bf83e6ea38ce643abf50df2a3b"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "enchant"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %w[
      -Dgtk_doc=false
      -Dtests=false
      -Dinstall_tests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gspell/gspell.h>

      int main(int argc, char *argv[]) {
        const GList *list = gspell_language_get_available();
        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkg-config --cflags --libs gspell-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    ENV["G_DEBUG"] = "fatal-warnings"

    # This test will fail intentionally when iso-codes gets updated.
    # Resolve by increasing the `revision` on this formula.
    system "./test"
  end
end
