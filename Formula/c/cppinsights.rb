class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_19.1.tar.gz"
  sha256 "88853a67b9eaf6917c531071436a275c62f1dcfe6f2e02e521c39ce81b05e6a7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "afe0e099c28067cf56276d9165c0c74d5bd60bc1198e35e48cd77a1583e37622"
    sha256 cellar: :any,                 arm64_sonoma:  "ee190f27380bb741eb5b8227bab92af141d582de278914da3d339936cb47e7a2"
    sha256 cellar: :any,                 arm64_ventura: "4410e7e48ebab10cabdb2090f2da11bbfe873e77807c7f3c9c85205d476633b4"
    sha256 cellar: :any,                 sonoma:        "f4790d0acad044e7c039f5d148871c9746c7b79d87a6f66c9594628a04aade18"
    sha256 cellar: :any,                 ventura:       "af24d6cdefa935d7cca9fbc28ae6133b4a1341a6bc3930d3e91b77c131bdd02e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d84b7f52fa94bf59a784cce74e72456b6e94436775f9895ecc96cade7b3866f2"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with :clang do
    build 1500
    cause "Requires Clang > 15.0"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    args = %W[
      -DINSIGHTS_LLVM_CONFIG=#{Formula["llvm"].opt_bin}/llvm-config
      -DINSIGHTS_USE_SYSTEM_INCLUDES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      int main() {
        int arr[5]{2,3,4};
      }
    CPP
    assert_match "{2, 3, 4, 0, 0}", shell_output("#{bin}/insights ./test.cpp")
  end
end
