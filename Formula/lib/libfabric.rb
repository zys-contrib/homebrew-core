class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v2.0.0/libfabric-2.0.0.tar.bz2"
  sha256 "1a8e40f1f331d6ee2e9ace518c0088a78c8a838968f8601c2b77fd012a7bf0f5"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "53db554a6bfa1c550717bbb5c69381a2b9a6e4e7c8da97b7442a5f614aa4e02b"
    sha256 cellar: :any,                 arm64_sonoma:   "89412889917d484d03bb9876eda676c9d777837f8f500e637d41a189e5b03f83"
    sha256 cellar: :any,                 arm64_ventura:  "20191f9f094e0905274ec9a193d2bc0f24ed1d0d67a8ed26bd612b8f0a37865f"
    sha256 cellar: :any,                 arm64_monterey: "f4e5fa18fc8d3aaa8af4204597e0218556921e8dfc49911b3035bb6a2c588aed"
    sha256 cellar: :any,                 sonoma:         "4e7cd495203660ba7f4eeaf10b2853979aa1e80692e14c7a8cecfcb3ac2c690c"
    sha256 cellar: :any,                 ventura:        "710a509782eaad6115ff37d71213dca17e382a9abfb5baac6c1df7f99fcbf32a"
    sha256 cellar: :any,                 monterey:       "8924e288d03c033e7200729dbcba6a84f55d0f45e2509729ca430a7fc2cd9c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af0d9ff3334d897ed6f253a45b123d65aa51a9c4dfd559a5ff427081591cd48b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
