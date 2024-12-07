class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview/-/archive/299.4.0/libgedit-gtksourceview-299.4.0.tar.bz2"
  sha256 "a2b4901b50fa2f7c5f968576e2d556b5e8e51ad264ab0d7b0e9aadced3b88f8a"
  license "LGPL-2.1-only"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "5d7d1aefaf79cf1cf19a50e94812e1767af9ee11149b5d5a3b547837e8486543"
    sha256 arm64_sonoma:  "329f8d227c0007ac511c90845dda40e4d8427196ed326818f28b8896ab0bf69c"
    sha256 arm64_ventura: "fb5deffe89409ad7aa5322d315cbf9d8bb96a13ede617eec2d1b54caaa188da0"
    sha256 sonoma:        "811a923e4a5762e42ce820958ad2cece6165976d3930c48eca9f3cb3e234c481"
    sha256 ventura:       "82ed993f73f88b32a38f5e561e234be92f227ede5d37a1bdccf9aba1afd53643"
    sha256 x86_64_linux:  "34fb0f2b288c781c158871ecf66ef9360e6b02f716252dfc71ad0067a25ba6f4"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libxml2" # Dependent `gedit` uses Homebrew `libxml2`
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgedit-gtksourceview-300").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
