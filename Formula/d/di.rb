class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-5.0.4.tar.gz"
  sha256 "2055abd8501cfc376b34f6fd69a32ed949ff26325ce57df5c82a3d8f71bab76b"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "005951181aca08346bda568288bc347e26d26dc0c2acf08567989fc52597ed00"
    sha256 cellar: :any,                 arm64_sonoma:  "d42477916c6f7a69b5da794afe27ff2e4cf443e07bb5856ca1903df2119cdd85"
    sha256 cellar: :any,                 arm64_ventura: "8edd76b37d5e4786e0928a7ff7da1a2b3aae4397e4a35ac0654db185307c8a44"
    sha256 cellar: :any,                 sonoma:        "5d3f84d67fa599a8788494538cbe754674bf91d2f6767bd7fcaf5f5f40734edd"
    sha256 cellar: :any,                 ventura:       "bfdeac756dbb2496c8b4a9a359e76cf36c29c39e7d0c3b15607856fd90f23db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c36f72e69adacf3ee8004d1b1120220a3c06d7c453d4a6dadaccd35255e0e4"
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
