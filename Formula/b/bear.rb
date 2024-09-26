class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "049b0bb3cf262440183b325e25808af829aa98f67c32194724125c17bcd109d5"
    sha256 arm64_sonoma:  "7a9f49ef347ef60f95c704e827fb784ba286d86c6e3caf44a2c527c2392ac6b3"
    sha256 arm64_ventura: "a1f30ab93d5d68d42f5ff719fb635480d0fc4705ffcfbc8110e376fccb5d5606"
    sha256 sonoma:        "11e6a4f62174a67ff24ebea3786a766a359264776eb6e82b779a41ede3de8996"
    sha256 ventura:       "56bf5e1395aa143f209408de9b198a9cc032fe8a142a43c058795da7b7f9fdef"
    sha256 x86_64_linux:  "ea288b78bfbbf0b1adbd81faf51a3fa83ef815778f22c5e8afbd51c749e1888f"
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
