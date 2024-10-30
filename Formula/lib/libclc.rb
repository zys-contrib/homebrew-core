class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.3/libclc-19.1.3.src.tar.xz"
  sha256 "b49fab401aaa65272f0480f6d707a9a175ea8e68b6c5aa910457c4166aa6328f"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24124f8c759b0933640c2cf0ed4db88c8cd1bf6a71163282851726bd397d39c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24124f8c759b0933640c2cf0ed4db88c8cd1bf6a71163282851726bd397d39c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24124f8c759b0933640c2cf0ed4db88c8cd1bf6a71163282851726bd397d39c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "24124f8c759b0933640c2cf0ed4db88c8cd1bf6a71163282851726bd397d39c8"
    sha256 cellar: :any_skip_relocation, ventura:       "24124f8c759b0933640c2cf0ed4db88c8cd1bf6a71163282851726bd397d39c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b813da7301e7bd25f0ab6f8dca191e5f54d52fe9057885c2773461d6176739"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator"].opt_bin/"llvm-spirv"
    system "cmake", "-S", ".", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share/"pkgconfig/libclc.pc", prefix, opt_prefix
  end

  test do
    clang_args = %W[
      -target nvptx--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}/clc/nvptx--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm"].opt_bin

    (testpath/"add_sat.cl").write <<~EOS
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    EOS

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    assert_match "@llvm.sadd.sat.i8", shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
  end
end
