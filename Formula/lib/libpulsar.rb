class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.7.0/apache-pulsar-client-cpp-3.7.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.7.0/apache-pulsar-client-cpp-3.7.0.tar.gz"
  sha256 "3223cfeda484ab7b580f4a8768b5a85739cc064005c765c06cde67c3238639c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1bb7bf6eaf3e6e92977bb797544ce31fdad49910ec0bd375db0ea4789ab35945"
    sha256 cellar: :any,                 arm64_sonoma:  "874285b114c6691197709c1b7cbc248a5435b63c0504af23859996beea7fff4f"
    sha256 cellar: :any,                 arm64_ventura: "6b4ccbda0803501d327b27cb8afa56d49b3c6cfef5750607ba31d6ee05a2bab0"
    sha256 cellar: :any,                 sonoma:        "68d58c966df0f5d5a71779773c6bb543098220a54c9b6fa87247bb0dbc1b184f"
    sha256 cellar: :any,                 ventura:       "8ab149de3f777c4c65b78eea95b709fb97323c9e6c2f0d2a80355dc8970e61f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78b634da78a5ce40542ae9d4e18cd0e2cc5aa0399c54acdb345a16402e044433"
  end

  depends_on "asio" => :build # FIXME: Not compatible with Boost.Asio 1.87+
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "abseil"
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
      -DUSE_ASIO=ON
    ]

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
