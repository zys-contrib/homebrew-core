class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.9.tar.gz"
  sha256 "8a9aa2ba9a25f936e241eaa6bb7e39bc1a097d178c4b255fa36795c0457e3f4e"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ccad92003aa4564081d04f2b35b69101ad94582265932958c0f4c7ea7a7f9661"
    sha256 cellar: :any,                 arm64_sonoma:  "3b26a35aa120bdb007628ef58b772fc6c8df713f0a5862ce0e426fcbfe1ef797"
    sha256 cellar: :any,                 arm64_ventura: "12fc9ad7c9817a96475a9f401db4b55ab7f09873f3d98715e5e22799a4a1d122"
    sha256 cellar: :any,                 sonoma:        "2b5cda86c7a4a8ad55f2962496ae66708c6226dab854a24850c07d3f0e6ddf06"
    sha256 cellar: :any,                 ventura:       "7422e41388cddc6c5a2a6b1571ea974783d29b596f554e3a040f937e3e19691e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24eaccec97d1a153dbb731e8cc7efa428df7afce884f689e0dd039a864ef4abf"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  conflicts_with "aws-sdk-cpp", because: "both install s2n/unstable/crl.h"

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
