class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.21/libxmlb-0.3.21.tar.xz"
  sha256 "642343c9b3eca5c234ef83d3d5f6307c78d024f2545f3cc2fa252c9e14e4efd1"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "fdc2e6dab7e1213110a6d1d6ae5d3c9ecb2ba9bf1137ccb5b0c312501e8c76ef"
    sha256 cellar: :any, arm64_sonoma:  "67355c408d16245ec4f4f1b4a8246e61b0eabebf0059d50725ad2c8be8c94b8b"
    sha256 cellar: :any, arm64_ventura: "3211a18bbe0051fd51e240e9ca6a208b408ee2e474fab4f3de0629238339b2e8"
    sha256 cellar: :any, sonoma:        "ae955601c5f1320d8950e9bd20028fff0b5c98ecc9280fe88b80073c9cf0e405"
    sha256 cellar: :any, ventura:       "9cd43c3fc4380adbcc16ac2274423527460ebb66a773a7e983dc272a06634421"
    sha256               x86_64_linux:  "aa0c9bde3e9c395f4d8e949030843cd62767eaabbf7a218281028053b63daf3e"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.13" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "xz"
  depends_on "zstd"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "src/generate-version-script.py"

    system "meson", "setup", "build",
                    "-Dgtkdoc=false",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"xb-tool", "-h"

    (testpath/"test.c").write <<~EOS
      #include <xmlb.h>
      int main(int argc, char *argv[]) {
        XbBuilder *builder = xb_builder_new();
        g_assert_nonnull(builder);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    xz = Formula["xz"]
    flags = %W[
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libxmlb-2
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{xz.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lxmlb
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
