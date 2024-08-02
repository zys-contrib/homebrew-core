class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview/-/archive/299.2.1/libgedit-gtksourceview-299.2.1.tar.bz2"
  sha256 "b183a816f3958df4bf5e186fef6f9a9e31d7747e6fafecc5cf1650b4807920b5"
  license "LGPL-2.1-only"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "e72a85aa5b87ec2d2850ec41a7d3158e7c9986658eee1c5537aa4955e753941a"
    sha256 arm64_ventura:  "6a84792b3059fc936cac45e119797837c714330baa198adf86ecbc09585cc6df"
    sha256 arm64_monterey: "7ef58b13dcd1eac1ce8c28b2198960bea396d7df32ea7cff874af54cbc2379df"
    sha256 sonoma:         "9d89906aaab6d10aa7e874892d12e2729ff0f19c489f376ae011e57b00ca1ef6"
    sha256 ventura:        "cb784238f49a9212ddffb8d301ff4e674355e360bd1c5c999a0c8ac782a79b81"
    sha256 monterey:       "afef3516cff41ec6eeb76c07794941ec254d3b1b64495676ca1ec7f9f5367e9e"
    sha256 x86_64_linux:   "704afbcba67f32813fca21c5534469f529e85e8e6567b53e3f54c2180dd374ba"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
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
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS

    flags = shell_output("pkg-config --cflags --libs libgedit-gtksourceview-300").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
