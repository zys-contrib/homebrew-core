class Plutovg < Formula
  desc "Tiny 2D vector graphics library in C"
  homepage "https://github.com/sammycage/plutovg"
  url "https://github.com/sammycage/plutovg/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "8aa9860519c407890668c29998e8bb88896ef6a2e6d7ce5ac1e57f18d79e1525"
  license "MIT"

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DPLUTOVG_BUILD_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/smiley.c"
  end

  test do
    system ENV.cc, pkgshare/"examples/smiley.c", "-o", "smiley", "-I#{include}/plutovg", "-L#{lib}", "-lplutovg"
    system testpath/"smiley"
    assert File.size("smiley.png").positive?
  end
end
