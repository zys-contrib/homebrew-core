class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.169.tar.gz"
  sha256 "984db86732160d64d6f477b9953966698f1ad1796b02766e53a5866d944d9e4a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a9f79c3b50f205ca1fa254df2d6b2b541b1e07b2fc9f828584d39f9236449c1"
    sha256 cellar: :any,                 arm64_sonoma:  "e979eee135da170de0677fd77b720c6a80d3036b5cb144dd4598c72f6ffdf474"
    sha256 cellar: :any,                 arm64_ventura: "ebb483dc40b1439bfcce1fb657652d483993ff77af12441d4b2a949a5623642f"
    sha256 cellar: :any,                 sonoma:        "7d4e8a64453d882d50a9f47948f9e0d78c85359288517c2d77d5e0dddcab4e55"
    sha256 cellar: :any,                 ventura:       "055ad5a63544ab60dc32970ed1160a23748e2122ffc4e09acab33ee6380b4f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b075d16ecd6cc863ca23640f834951830b7ddc4f7d0de14d55ab2dbf837d3446"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
