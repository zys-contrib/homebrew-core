class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.12.2.tar.gz"
  sha256 "8ac7c97073d5079f54ad66d04381ec75e1169c2e20bfe9b6500bc81304da3faf"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47b9c4d1e78767e72a9e7dd7518b20133dced32474e032e96b728c4c4f993021"
    sha256 cellar: :any,                 arm64_sonoma:  "be1f72f81d40f3dff25d40303d3088571c1896cbf559bf1bab1c0d6287197a5e"
    sha256 cellar: :any,                 arm64_ventura: "312c4107ce8adbcb7701b656cc712bddca8c5186f424ba30c11c7a99c0c0c46a"
    sha256 cellar: :any,                 sonoma:        "2b699b1ea3cf4c6c133ed4ad213776044172434b66a16b884bcbd4c5626b322a"
    sha256 cellar: :any,                 ventura:       "87e122ecee7ba3378990dd51f055ae6f13bbdde72120a5484543b37795157d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "752858f2e9cbc772218a1bebf7da79c27cfc00745580bc13341d625de13e75b0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build"
    lib.install "build/libsimdjson.a"
  end

  test do
    (testpath/"test.json").write "{\"name\":\"Homebrew\",\"isNull\":null}"
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end
