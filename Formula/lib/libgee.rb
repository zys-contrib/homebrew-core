class Libgee < Formula
  desc "Collection library providing GObject-based interfaces"
  homepage "https://wiki.gnome.org/Projects/Libgee"
  url "https://download.gnome.org/sources/libgee/0.20/libgee-0.20.8.tar.xz"
  sha256 "189815ac143d89867193b0c52b7dc31f3aa108a15f04d6b5dca2b6adfad0b0ee"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "2e94fefbe95465772e0676f4d0f65ae212867caeaf659921e069ae1f153e5c4e"
    sha256 cellar: :any,                 arm64_sonoma:   "0f3ac7bcee7e8a3ef342362cc6fb67c7f20f6e616ccaebe0b6d187069498f559"
    sha256 cellar: :any,                 arm64_ventura:  "648c253edc216944b0e678393a1376050dce9c2136a2e23543e0c2c399d9c27b"
    sha256 cellar: :any,                 arm64_monterey: "4db78ce506f169e6cf5e958f3fe5b53b53cd8b89658b27177021d38446705ec1"
    sha256 cellar: :any,                 sonoma:         "81a4559f30db3797dc6f91af8e0cc639814ddbb36a625fdfcaad51de153a7990"
    sha256 cellar: :any,                 ventura:        "49e93aa588f553b9781e84a7e9e0e9fe2dcb511976218ef2385983da6e318d67"
    sha256 cellar: :any,                 monterey:       "1514560672301f3b58ea438cbe537af7e878b0def106674bee39f022902a2508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfcece11cd71b887bf40f1ea11e69d2fdb14133ae914b1d67858213b6e49fe0c"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    # ensures that the gobject-introspection files remain within the keg
    inreplace "gee/Makefile.in" do |s|
      s.gsub! "@HAVE_INTROSPECTION_TRUE@girdir = @INTROSPECTION_GIRDIR@",
              "@HAVE_INTROSPECTION_TRUE@girdir = $(datadir)/gir-1.0"
      s.gsub! "@HAVE_INTROSPECTION_TRUE@typelibdir = @INTROSPECTION_TYPELIBDIR@",
              "@HAVE_INTROSPECTION_TRUE@typelibdir = $(libdir)/girepository-1.0"
    end

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gee.h>

      int main(int argc, char *argv[]) {
        GType type = gee_traversable_stream_get_type();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gee-0.8").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
