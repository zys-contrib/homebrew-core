class Lunasvg < Formula
  desc "SVG rendering and manipulation library in C++"
  homepage "https://github.com/sammycage/lunasvg"
  url "https://github.com/sammycage/lunasvg/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "06045afc30dbbdd87e219e0f5bc0526214a9d8059087ac67ce9df193a682c4b3"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "plutovg"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DUSE_SYSTEM_PLUTOVG=ON
      -DLUNASVG_BUILD_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/svg2png.cpp"
  end

  test do
    args = %W[
      -std=c++11
      -I#{include}/lunasvg
      -I#{Formula["plutovg"].opt_include}/plutovg
      -L#{lib}
      -L#{Formula["plutovg"].opt_lib}
      -llunasvg
      -lplutovg
    ]

    system ENV.cxx, pkgshare/"examples/svg2png.cpp", "-o", "svg2png", *args
    system testpath/"svg2png", test_fixtures("test.svg")
    assert File.size("test.svg.png").positive?
  end
end
