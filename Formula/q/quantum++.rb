class Quantumxx < Formula
  desc "Modern C++ quantum computing library"
  homepage "https://github.com/softwareQinc/qpp"
  url "https://github.com/softwareQinc/qpp/archive/refs/tags/v6.0.tar.gz"
  sha256 "cdd6acf287b2f2dd124120ef2aba85660eee9482f5484dbd229c93b53a7d8a54"
  license "MIT"
  head "https://github.com/softwareQinc/qpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ff3efd01b8a28045694ee46bc49bdbf510652e6318fcf3a7976b545aed1e53d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :build
  depends_on "eigen"
  depends_on "pybind11"

  def install
    args = %w[
      -DFETCHCONTENT_FULLY_DISCONNECTED=OFF
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)
      project(qpp_test)
      set(CMAKE_CXX_STANDARD 17)

      find_package(qpp REQUIRED)
      add_executable(qpp_test qpp_test.cpp)
      target_link_libraries(qpp_test PUBLIC ${QPP_LINK_DEPS} libqpp)
    CMAKE
    (testpath/"qpp_test.cpp").write <<~CPP
      #include <iostream>
      #include <qpp/qpp.hpp>

      int main() {
          using namespace qpp;
          std::cout << disp(transpose(0_ket)) << std::endl;
      }
    CPP
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_equal "1  0", shell_output("./build/qpp_test").chomp
  end
end
