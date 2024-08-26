class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2024.08.26.00.tar.gz"
  sha256 "7f08016988ca146c77ced2fafd2ae6b39159ab7f99e7eb0c3e8eeed8dc09c03d"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4acb5936eb74dcca005614666040dcd1c2dd3cbfe4489babe3e10de5ca051ef8"
    sha256 cellar: :any,                 arm64_ventura:  "dcdae51bcd1a522b721215b8f6d1a16db9b081565c968f8cfc1b328119074218"
    sha256 cellar: :any,                 arm64_monterey: "0d270c70e9e31142dc0f18659034cabe8c3997edfa2f451505b91ef53f99437d"
    sha256 cellar: :any,                 sonoma:         "b3897e60c8366a745e7cda543435156375eb63feb108212f1a158906174fe496"
    sha256 cellar: :any,                 ventura:        "736163f2f5555b07075f0d77e911bd8d4ebd8d9f7cf8dcdd420a53fc6a531395"
    sha256 cellar: :any,                 monterey:       "62f436cb10802a833e82f66468d8b501e2a36a7ab4829adfba7bcfb463b16aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "208f8f1c0fc5dc5adca5351b5a3c5996839bda630ba39d354a0164b3b6914fb0"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath/"test.cc").write <<~EOS
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
