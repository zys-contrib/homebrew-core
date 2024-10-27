class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.net/"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.11.0/gnupg-pkcs11-scd-0.11.0.tar.bz2"
  sha256 "954787e562f2b3d9294212c32dd0d81a2cd37aca250e6685002d2893bb959087"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/gnupg-pkcs11-scd[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "306ec3bbfc7f29c826c071461af2585f0759bab3e49c11aaa42181f0950ab8ab"
    sha256 cellar: :any,                 arm64_sonoma:  "554ec82459c766488cfa01e5a2ac16b9c576badba3848ae5d2f90b89e2dadabb"
    sha256 cellar: :any,                 arm64_ventura: "e4d76440af9ca88fe628307bcef9a9313ad8ae2d07c40ed3367fa82e8c386b7b"
    sha256 cellar: :any,                 sonoma:        "271520fe7493472155570298cb379f0f08da53a7de947e448e5c499e3fe680b5"
    sha256 cellar: :any,                 ventura:       "3e9b548b5a804619036a14524f563fc360846826868f700ac08057d3ddd68784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0635d9f5f524a8de9291d9608fe4eee289f973156f2d6e10dd58e4edefe7481"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"gnupg-pkcs11-scd", "--help"
  end
end
