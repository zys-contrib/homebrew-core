class RapidfuzzCpp < Formula
  desc "Rapid fuzzy string matching in C++ using the Levenshtein Distance"
  homepage "https://github.com/rapidfuzz/rapidfuzz-cpp"
  url "https://github.com/rapidfuzz/rapidfuzz-cpp/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "5a72811a9f5a890c69cb479551c19517426fb793a10780f136eb482c426ec3c8"
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
