class Xtl < Formula
  desc "X template library"
  homepage "https://github.com/xtensor-stack/xtl"
  url "https://github.com/xtensor-stack/xtl/archive/refs/tags/0.8.0.tar.gz"
  sha256 "ee38153b7dd0ec84cee3361f5488a4e7e6ddd26392612ac8821cbc76e740273a"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "nlohmann-json"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include "xtl/xcomplex.hpp"

      using complex_type = xtl::xcomplex<double>;

      int main() {
        complex_type vc0(1., 2.);
        complex_type vc1(2., 4.);
        complex_type c2 = vc0 * vc1;
        std::cout << c2.real() << "," << c2.imag() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "-6,8", shell_output("./test").strip
  end
end
