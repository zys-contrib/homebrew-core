class RapidfuzzCpp < Formula
  desc "Rapid fuzzy string matching in C++ using the Levenshtein Distance"
  homepage "https://github.com/rapidfuzz/rapidfuzz-cpp"
  url "https://github.com/rapidfuzz/rapidfuzz-cpp/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "ef0b8684b94df3ba3bbdf22055541373455354fdc64fd989569288959f04e603"
  license "MIT"
  head "https://github.com/rapidfuzz/rapidfuzz-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2589be1648419f98dffb3ddc3d134fc36f1332ee442813fb5076c75934a8f7e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <rapidfuzz/fuzz.hpp>
      #include <string>
      #include <iostream>

      int main()
      {
          std::string a = "aaaa";
          std::string b = "abab";
          std::cout << rapidfuzz::fuzz::ratio(a, b) << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-o", "test"
    assert_equal "50", shell_output("./test").strip
  end
end
