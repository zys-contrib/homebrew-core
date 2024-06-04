class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.4.tar.gz"
  sha256 "a1105023795b3e1b9abc29c088cdec5464cc9f3b640b5078dc90a505498da5ff"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "cb50e5a88d174912e34a41c51c1ef8f193b6eafbab972d136dbe109064d08d91"
    sha256 arm64_ventura:  "01a0d5579370c454398525f3c72bb92b310e0bf202ac174df9a35177280e44e2"
    sha256 arm64_monterey: "edc7acd1aee480fe46c0d40fd4a7216498ab89e66d908af14a260cb3bb475bcf"
    sha256 sonoma:         "8f8eb706ff957f90642b3032feab6a4d06882f441b2cb3f7a2ed0863f89ff90d"
    sha256 ventura:        "d713fbd4506a6d8ac522f6cbece8ebd9cd1397e3c6ebfa8e183221627e3cf61d"
    sha256 monterey:       "bdc23f1a639d3de0f63f4b8a382d79c3d03cd779f9eb061c7c8f7dbbccdd320e"
    sha256 x86_64_linux:   "918653a5eba51c9844c7e3d0c199fcd4fe5558c7a5122b1317bd9fbe9125418d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "protobuf"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with gcc: "5" # needs C++17

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__current_path(std::__1::error_code*)"
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
