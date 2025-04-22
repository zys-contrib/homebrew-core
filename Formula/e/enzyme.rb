class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.175.tar.gz"
  sha256 "e05b810eef8c92d19e43bfdd39ee2a5bcb6a67f9b61ef42b46d16464e07c125b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3e78134e761de2e6f0b5a49ecd4a8b8def7c4caa12f7677194cadcf8046f6190"
    sha256 cellar: :any,                 arm64_sonoma:  "7bee29b28765d3eb5f5f9af22151503233e7d936774c728c2f20e2e3083d2e88"
    sha256 cellar: :any,                 arm64_ventura: "6974a9bd5a8571c6dc24a5d2277fcbc543c222d555c876a742b65a6327871c26"
    sha256 cellar: :any,                 sonoma:        "d56fa5f7cd9dff29f704c82cc8f406e052470ef8b39093fcf104c12f331587ec"
    sha256 cellar: :any,                 ventura:       "392fc9f2e897decf845ddc7b1f864d6252af7ea2192bdced418c60db85e58070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b4aa20ddbc1aa06f867f18ff90d2d014eb891e86dcdf757e6675cfa159102bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73beea576e47541b648697a84f6de77e052074720bbd1fe28fc93241a585687"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
