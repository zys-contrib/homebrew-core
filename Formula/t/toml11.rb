class Toml11 < Formula
  desc "TOML for Modern C++"
  homepage "https://github.com/ToruNiina/toml11"
  url "https://github.com/ToruNiina/toml11/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "af95dab1bbb9b05a597e73d529a7269e13f1869e9ca9bd4779906c5cd96e282b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "84bfa4e70fe6d9776c51d72cde650db44fa61e1a930bc1256263d233e6689559"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=11",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.toml").write <<~TOML
      test_str = "a test string"
    TOML

    (testpath/"test.cpp").write <<~CPP
      #include "toml.hpp"
      #include <iostream>

      int main(int argc, char** argv) {
          const auto data = toml::parse("test.toml");
          const auto test_str = toml::find<std::string>(data, "test_str");
          std::cout << "test_str = " << test_str << std::endl;
          return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "test_str = a test string\n", shell_output("./test")
  end
end
