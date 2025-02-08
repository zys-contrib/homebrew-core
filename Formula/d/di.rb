class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-5.0.5.tar.gz"
  sha256 "47522146deab224f94df02e67c5256295795690cf70f6a71d361f3efc497a175"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "973de4c212f2d28f4a7f0fc538f85b345de2402576128e7e17b16bd2f24c956a"
    sha256 cellar: :any,                 arm64_sonoma:  "2be939391c59f035be7526bfcf628b8803ce4f4157faefff9529326a66b71db6"
    sha256 cellar: :any,                 arm64_ventura: "f61a8820453cd04361d055115b668aad1bbcede7fc42c89ecc891b1c8fca1dff"
    sha256 cellar: :any,                 sonoma:        "4adff654b0882bd34bb590d33a48dfe92a9e64ebc9a8145e7eb99c677d2483c4"
    sha256 cellar: :any,                 ventura:       "d89d5db581c8ed2a39a50d1664261fa5e41757c7d6489ec831e607edfa76b74c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a71c917376e63e5a37fff504ffdb4f3acc46112b5edf3add5e41941f25ac87e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    args = %W[
      -DDI_BUILD=Release
      -DDI_VERSION=#{version}
      -DDI_LIBVERSION=#{version}
      -DDI_SOVERSION=#{version.major}
      -DDI_RELEASE_STATUS=production
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di --version")
    system bin/"di"
  end
end
