class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.147.tar.gz"
  sha256 "3d41c049488e5bfb2771c8ebd667fe6150e2762f3cf103b1eacef8287e8c8a8b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4bb3acf6954dca99d96a4d3e185118fe3522f5e9152daa781f7a153c82d2c556"
    sha256 cellar: :any,                 arm64_ventura:  "ed4880a0db416109d629ccd837f79dc642fe1cbeb300b97a9261f3e02a1c323c"
    sha256 cellar: :any,                 arm64_monterey: "a83e1b8049f91d6c894989d062af61e4dbc33215561c1fc8e127b7d308a7419b"
    sha256 cellar: :any,                 sonoma:         "e336053c8fc65064dad76e5769515d5eee1f174e50eb39986c851d8cd13e57b1"
    sha256 cellar: :any,                 ventura:        "2e63c92d78e408e60fc14778b7d82986620467f61944182e15a58f277e47c8d9"
    sha256 cellar: :any,                 monterey:       "496230c634044f934897c20036bf8911e9584cf56389e579b986f63f17d2dbfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "249368e3da19de47c679acc41746346e4e4caf6c0887b10c9aaef815e1e747b2"
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
