class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.178.tar.gz"
  sha256 "46323d247ce25fd415a597e56468433abe6a0388ffc117f72c2d9acbd0f52e64"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "884fc492dc61521d43b8b4e56df70a975ac38bb77782e9a8fc37135d766149a2"
    sha256 cellar: :any,                 arm64_sonoma:  "7e38329ae7b6897e8c537a3fece321bbbee4cd7a1a93b4048bf5e33f2a80cc32"
    sha256 cellar: :any,                 arm64_ventura: "5a67e81309c384d88cff64a72eb2b74df6f2efc1df7395746e29c55f006028a3"
    sha256 cellar: :any,                 sonoma:        "350e9d8e2aa2edfff9dfc1b15792bf8b0194ea36ea15e96326e5249608872650"
    sha256 cellar: :any,                 ventura:       "cecc79db2abb25992f455323794921782c1feba032d9b15acd9cd0090032bac2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "671a24130661892aaf3335295a71ae3560e131ac18bff848ce80c58c93d5469e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a70e0d70cc0ec7eebcc2e612858827fe19610f6a743bc1faf5d095e69c3ed449"
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
