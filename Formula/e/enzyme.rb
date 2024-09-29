class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.152.tar.gz"
  sha256 "e1afd7731d183759831578ef82e1a2f4f8884202efcd8e03425242736dc43bb3"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c1b36504d99b60c01afe3f8efbbe0a0f38516543f6c56278e63e217fc15b21e3"
    sha256 cellar: :any,                 arm64_sonoma:  "0f21084858097b0b8c936cae27fbd16d1ff27c78be285134273a07d5653dcd0c"
    sha256 cellar: :any,                 arm64_ventura: "805b315f083252a8fecd051673e5ac6820a0eaf153275abe474e8d0e0fdfca25"
    sha256 cellar: :any,                 sonoma:        "cfa5a49d53f6e8feae05c59d586aeb16aa5cfc73d83f0620db1f70f1fe801d86"
    sha256 cellar: :any,                 ventura:       "ff4caebc539a698aa3c800b0fc1ee804fc3d66bec4cb3e069006dd51f2f865dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1945218c8ab85b3028cd4fb5df52b0e6df1b29ff191f76255d87bed60d21dcc6"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
