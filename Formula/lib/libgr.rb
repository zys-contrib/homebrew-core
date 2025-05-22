class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.16.tar.gz"
  sha256 "a9eb77caa0b28f46cd7e5c5318a56f75af28c9306fa802fbb10f7b3d332d71a6"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:  "25d75e0c573e987d0035a222f568cecc3f73fce26cf4640a26b8962bba2f8285"
    sha256 arm64_ventura: "c0b9b2054536961ef7fefccec928e621606cade0cf47227e38f04347a7c64200"
    sha256 sonoma:        "c38bf438c727c03e4fa72ca074954f1055ae5af3584a353bc34090e711db89bd"
    sha256 ventura:       "2976d95df169970922aaa0e1f915e2cc6aaf394f97224b2f2600ea325f89c87c"
    sha256 x86_64_linux:  "251dbe2c16cb42b6ee3c2ad8f03df31e5b0c993176e7efc2bb1f8c0269d09717"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pixman"
  depends_on "qhull"
  depends_on "qt"
  depends_on "zeromq"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxt"
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <gr.h>

      int main(void) {
          gr_opengks();
          gr_openws(1, "test.png", 140);
          gr_activatews(1);
          double x[] = {0, 0.2, 0.4, 0.6, 0.8, 1.0};
          double y[] = {0.3, 0.5, 0.4, 0.2, 0.6, 0.7};
          gr_polyline(6, x, y);
          gr_axes(gr_tick(0, 1), gr_tick(0, 1), 0, 0, 1, 1, -0.01);
          gr_updatews();
          gr_emergencyclosegks();
          return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lGR"
    system "./test"

    assert_path_exists testpath/"test.png"
  end
end
