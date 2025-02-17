class Wfa2Lib < Formula
  desc "Wavefront alignment algorithm library v2"
  homepage "https://github.com/smarco/WFA2-lib"
  url "https://github.com/smarco/WFA2-lib/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "2609d5f267f4dd91dce1776385b5a24a2f1aa625ac844ce0c3571c69178afe6e"
  license "MIT"
  head "https://github.com/smarco/WFA2-lib.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", "-DOPENMP=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/wfa_basic.c", "-o", "test", "-I#{include}/wfa2lib", "-L#{lib}", "-lwfa2", "-lm"
    assert_match "WFA-Alignment returns score -24", shell_output("./test 2>&1")
  end
end
