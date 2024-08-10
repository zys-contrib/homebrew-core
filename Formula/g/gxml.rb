class Gxml < Formula
  desc "GObject-based XML DOM API"
  homepage "https://wiki.gnome.org/GXml"
  url "https://gitlab.gnome.org/GNOME/gxml/-/archive/0.20.4/gxml-0.20.4.tar.bz2"
  sha256 "d8d8b16ff701d0c5ff04b337b246880ec4523abfe897a1f77acdf7d73fb14b84"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "54c6ed5a3a82484145eb346f51f2e76b6477a362f26e2b3cf08c15e45e4ea818"
    sha256 arm64_ventura:  "c8f3e38d52c9c7628bdf87e483750c871a429ea8e68e018b5c15bb0d4aaa1020"
    sha256 arm64_monterey: "368c6d6ab14ce46ee5e339801b8290219ff34a63d38a5815b12c47a7f8d77ffe"
    sha256 sonoma:         "01dd745d114b9f98d1823e9b4fd4fc53bea776c1df994bb5b8e3128ebe78b294"
    sha256 ventura:        "adf748f00b1956efe7c2bdd6fcdaa415b9987c54b0dbeb547598ed3a21dc684b"
    sha256 monterey:       "10ad638f4cce9ec42b6d3d1f157a57a4d1abc6b5c8d76acf786f74df76145b00"
    sha256 x86_64_linux:   "dcea35a54aaa49782fdacee3e59098d9385a80e6ccca1b06a631bbbfe6b0c3da"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "libgee"
  depends_on "libxml2"

  on_macos do
    depends_on "gettext"
  end

  # fix version comparison in gxml.pc.in, upstream pr ref, https://gitlab.gnome.org/GNOME/gxml/-/merge_requests/28
  patch do
    url "https://gitlab.gnome.org/GNOME/gxml/-/commit/6551103abd5143e51814ec1dce9b36bb9a46e09f.diff"
    sha256 "b87f585ab782b2ff4f024c45c9a90791c2023e3703756f2eb799591e7978e640"
  end

  def install
    system "meson", "setup", "build", "-Dintrospection=true", "-Ddocs=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gxml/gxml.h>

      int main(int argc, char *argv[]) {
        GType type = gxml_document_get_type();
        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libxml2"].opt_lib/"pkgconfig"
    pkg_config_flags = shell_output("pkg-config --cflags --libs libxml-2.0 gxml-0.20").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
