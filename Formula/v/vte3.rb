class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.78/vte-0.78.4.tar.xz"
  sha256 "2dea4e412266592b6460a3fe4488f5e3d50712f139815790c0ecb44710f7e17e"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "611afe0a8dad1445b2ccd59139731b0d27274b4f355781cb087944c96fc4ce94"
    sha256 arm64_sonoma:  "f924c2f69b6c48e6f4f6630bf89a46af6cd8672abb992fa64987880988f0734a"
    sha256 arm64_ventura: "8e4b04daf51ec10f85160c150747b32b48249589489a668f8ec565383fce5afd"
    sha256 sonoma:        "88270d57094a08936b9e472deb60113efd5b6b0dd8bef3283b29ad63d824a9ca"
    sha256 ventura:       "04305fb0746b9f545466f90b0cfd533b36d242aca233179ba4448c3ee5436e65"
    sha256 x86_64_linux:  "20d612959ffc55a1b1bb87e40c7c50725a80731a39727773bae37bd257dae51c"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "graphene"
  depends_on "gtk+3"
  depends_on "gtk4"
  depends_on "icu4c@77"
  depends_on "lz4"
  depends_on macos: :mojave
  depends_on "pango"
  depends_on "pcre2"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
    depends_on "gettext"
    # Undefined symbols for architecture x86_64:
    #   "std::__1::__libcpp_verbose_abort(char const*, ...)", referenced from: ...
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400

    # Use fast_float implementation for from_chars
    # upstream bug report, https://gitlab.gnome.org/GNOME/vte/-/issues/2823
    # TODO: Investigate using the `fast_float` formula instead of the one bundled here.
    patch do
      url "https://gitlab.gnome.org/kraj/vte/-/commit/2a32e43e43b04771a3357d3d4ccbafa7714e0114.diff"
      sha256 "f69f103b19de93f94fca05dea5a151b4109085ce716472acddb9a112502437d4"
    end
    patch do
      url "https://gitlab.gnome.org/kraj/vte/-/commit/705e019713539bdaf2c50763ba585484c6253a59.diff"
      sha256 "d09c512852a65a81f56b07c013ee0cc0c17b9dcbf63d9fcc2ac58173092bb80b"
    end
  end

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "systemd"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  # submitted upstream as https://gitlab.gnome.org/tschoonj/vte/merge_requests/1
  patch :DATA

  def install
    if OS.mac? && DevelopmentTools.clang_build_version <= 1500
      llvm = Formula["llvm"]
      ENV.llvm_clang
      if DevelopmentTools.clang_build_version <= 1400
        ENV.prepend "LDFLAGS", "-L#{llvm.opt_lib}/c++ -L#{llvm.opt_lib} -lunwind"
      else
        # Avoid linkage to LLVM libunwind. Should have been handled by superenv but still occurs
        ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib
      end
    end

    if ENV.compiler == :clang
      ENV.append "CXXFLAGS", "-stdlib=libc++"
      ENV.append "LDFLAGS", "-stdlib=libc++"
    end

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", "-Dgir=true",
                                      "-Dgtk3=true",
                                      "-Dgtk4=true",
                                      "-Dgnutls=true",
                                      "-Dvapi=true",
                                      "-D_b_symbolic_functions=false",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1500)

    (testpath/"test.c").write <<~C
      #include <vte/vte.h>

      int main(int argc, char *argv[]) {
        guint v = vte_get_major_version();
        return 0;
      }
    C
    flags = shell_output("pkg-config --cflags --libs vte-2.91").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    flags = shell_output("pkg-config --cflags --libs vte-2.91-gtk4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/meson.build b/meson.build
index e2200a75..df98872f 100644
--- a/meson.build
+++ b/meson.build
@@ -78,6 +78,8 @@ lt_age = vte_minor_version * 100 + vte_micro_version - lt_revision
 lt_current = vte_major_version + lt_age

 libvte_gtk3_soversion = '@0@.@1@.@2@'.format(libvte_soversion, lt_current, lt_revision)
+osx_version_current = lt_current + 1
+libvte_gtk3_osxversions = [osx_version_current, '@0@.@1@.0'.format(osx_version_current, lt_revision)]
 libvte_gtk4_soversion = libvte_soversion.to_string()

 # i18n
diff --git a/src/meson.build b/src/meson.build
index 79d4a702..0495dea8 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -224,6 +224,7 @@ if get_option('gtk3')
     vte_gtk3_api_name,
     sources: libvte_gtk3_sources,
     version: libvte_gtk3_soversion,
+    darwin_versions: libvte_gtk3_osxversions,
     include_directories: incs,
     dependencies: libvte_gtk3_deps,
     cpp_args: libvte_gtk3_cppflags,
