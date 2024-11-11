class Gplugin < Formula
  desc "GObject based library that implements a reusable plugin system"
  homepage "https://keep.imfreedom.org/gplugin/gplugin/"
  url "https://downloads.sourceforge.net/project/pidgin/gplugin/0.44.2/gplugin-0.44.2.tar.xz"
  sha256 "aea244e1add9628b50ec042c54cf93803f4577f8f142678f09b91fd4c0b20f72"
  license all_of: [
    "LGPL-2.0-or-later",
    "GPL-3.0-or-later", # gplugin-gtk4-viewer
  ]

  livecheck do
    url "https://sourceforge.net/projects/pidgin/rss?path=/gplugin"
  end

  depends_on "gobject-introspection" => :build
  depends_on "help2man" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk4"
  depends_on "pygobject3"
  depends_on "python@3.13"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Ddoc=false", "-Dlua=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gplugin.h>

      int main() {
        gplugin_init(GPLUGIN_CORE_FLAGS_NONE);
        GPluginManager *manager = gplugin_manager_get_default();
        gplugin_manager_add_default_paths(manager);
        gplugin_manager_refresh(manager);
        gplugin_uninit();
        return 0;
      }
    C

    flags = shell_output("pkg-config --cflags --libs gplugin").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
