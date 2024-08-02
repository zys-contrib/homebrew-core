class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-tepl"
  url "https://gitlab.gnome.org/World/gedit/libgedit-tepl/-/archive/6.10.0/libgedit-tepl-6.10.0.tar.bz2"
  sha256 "bfaf68a4c81b7e32ff69d102dad1d656c49b5ef8570db15327a3c5479c8c3164"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-tepl.git", branch: "main"

  # https://gitlab.gnome.org/swilmet/tepl/-/blob/main/docs/more-information.md
  # Tepl follows the even/odd minor version scheme. Odd minor versions are
  # development snapshots; even minor versions are stable.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "icu4c"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
  depends_on "libgedit-gtksourceview"
  depends_on "libhandy"
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
      #include <tepl/tepl.h>

      int main(int argc, char *argv[]) {
        GType type = tepl_file_get_type();
        return 0;
      }
    EOS

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkg-config --cflags --libs libgedit-tepl-6").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
