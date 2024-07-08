class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.132.tar.gz"
  sha256 "3fb829f59da6e180721c3c6ffc0cbf95906d4705037cea9d6c06230b09656a22"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46b2d44c0318006f02465b1f914addcc66a4a3c7f94db4088cbefe900d40b3ab"
    sha256 cellar: :any,                 arm64_ventura:  "92a0f082dade6e591f040d566538ce448ac6b1ecf4fc09547948605d8880c0b8"
    sha256 cellar: :any,                 arm64_monterey: "99ddc899c6ec82ed4d79468b0d6efb6f88646570aec61e26acf292cf57946dc3"
    sha256 cellar: :any,                 sonoma:         "9ebf66eddba1ad7aa68c175907285673db73dca1495ed750a1b8426a4c2b8e89"
    sha256 cellar: :any,                 ventura:        "38fcef6a5e72f947dfae8ff725f9bac8b07877fd23bfcce441bb3c4e9e1b1ee5"
    sha256 cellar: :any,                 monterey:       "100da37940abdcf1a32810c37b146dd3ecd6151bd82f5da4cfbeea13ae502f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67056c649cd8618c2aa3eafe7415fbda3751c31e160a10c96b6be23567cd668"
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
