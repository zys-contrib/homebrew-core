class Maeparser < Formula
  desc "Maestro file parser"
  homepage "https://github.com/schrodinger/maeparser"
  url "https://github.com/schrodinger/maeparser/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "a8d80f67d1b9be6e23b9651cb747f4a3200132e7d878a285119c86bf44568e36"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMAEPARSER_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test/MainTestSuite.cpp", "test/UsageDemo.cpp", "test/test2.maegz"
  end

  test do
    cp pkgshare.children, testpath
    system ENV.cxx, "-std=c++11", "MainTestSuite.cpp", "UsageDemo.cpp", "-o", "test",
                    "-DTEST_SAMPLES_PATH=\"#{testpath}\"", "-DBOOST_ALL_DYN_LINK",
                    "-I#{include}/maeparser", "-L#{lib}", "-lmaeparser",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_filesystem", "-lboost_unit_test_framework"
    system "./test"
  end
end
