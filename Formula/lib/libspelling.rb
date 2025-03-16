class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.6/libspelling-0.4.6.tar.bz2"
  sha256 "5625bbb3db35e8163c71c66ae29308244543316d0aeb8489d942fab9afd9222d"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "8ef3a05b6182b74aeabd5566a2bd0a17fe4b2ef67e6763e6c1b99053309b99b1"
    sha256 arm64_sonoma:  "63fc81f46db88333a5e85f67a73c41c122302750f62fd02cb0b9a496e5b743bd"
    sha256 arm64_ventura: "718cd3905b2f6355c7aee9012744e7eb8122c4f79d18143339c2f7cf83dc3ee1"
    sha256 sonoma:        "b427ef266cfbc4b19db63e9873c27cf288528a6116947f098bf8832cff770f9e"
    sha256 ventura:       "fa9b22aa5bf5444731300c18d03db36bb6ef80c8563fe06e742c766f0d86c993"
    sha256 x86_64_linux:  "86bd9e7cde9611c057d5d77e42324678342564606955b01a9808a0e6c39d1ab4"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "enchant"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "icu4c@77"
  depends_on "pango"

  on_macos do
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "graphene"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "sysprof"
  end

  def install
    system "meson", "setup", "build", "-Ddocs=false", "-Dsysprof=#{OS.linux?}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libspelling.h>

      int main(int argc, char *argv[]) {
        SpellingChecker *checker = spelling_checker_get_default();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libspelling-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
