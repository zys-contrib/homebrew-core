class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.sits.lu/xmount"
  url "https://code.sits.lu/foss/xmount/-/archive/1.1.1/xmount-1.1.1.tar.bz2"
  sha256 "ebabe4f2f37e34a4804b249b18421590bc241dcedff56b06f179c45d011027c7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 x86_64_linux: "c61ddafea43cbd071198031f80f4893a2fc90266a9daf1999e78a1b6211d748a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@3"].opt_lib/"pkgconfig"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"xmount", "--version"
  end
end
