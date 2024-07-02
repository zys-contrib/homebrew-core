class RapidfuzzCpp < Formula
  desc "Rapid fuzzy string matching in C++ using the Levenshtein Distance"
  homepage "https://github.com/maxbachmann/rapidfuzz-cpp"
  url "https://github.com/maxbachmann/rapidfuzz-cpp/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "e32936cc66333a12f659553b5fdd6d0c22257d32ac3b7a806ac9031db8dea5a1"
  license "MIT"
  head "https://github.com/maxbachmann/rapidfuzz-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "389eb01bf897402a8912fe918071117674784e5a0d7a79c3d6dc134179562907"
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
