class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.5.1/apache-pulsar-client-cpp-3.5.1.tar.gz"
  sha256 "d24990757319dfa9c9e5d3263f60105dd9e12ddeaf1396d6b397f87dab2fd7d1"
  license "Apache-2.0"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fcf3801068dd80931d5c3a1bd7242c3b70b464a166e0798fa61c23120aab3412"
    sha256 cellar: :any,                 arm64_ventura:  "af442baf8154b4700fe4105d51d09b31ebaecb75cf45d9c94391b980c42fff0d"
    sha256 cellar: :any,                 arm64_monterey: "2f378f1ad86582541a8a1ffe99f02a74167abd24dd19b25b818e2f273916a1c7"
    sha256 cellar: :any,                 sonoma:         "e202880b2f957a7c232effcadebfac4085dc761cfe75de262809fd59eceabb0e"
    sha256 cellar: :any,                 ventura:        "0e901f75a42859d36581c4fa7f6bab664aca98dea703ed196c9eb3439c8cea4f"
    sha256 cellar: :any,                 monterey:       "96e2f5069219f6984b888446371d88fdf73b9fece5aab77ec2b4a64576d2bf54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4ee42407e3276c7f6551f2631791b66835cfdade8e6743a6147d1edd9dd1fdc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "abseil"
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
    ]

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    EOS

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
