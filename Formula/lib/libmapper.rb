class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://github.com/libmapper/libmapper/releases/download/2.4.11/libmapper-2.4.11.tar.gz"
  sha256 "971d878b650e5e28e44da2efa6499d92bb59566bca37e0a7185c958dd9bf5a12"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ec8236e499f58d361324ed30ee024e15c681aef952caff9cb52cf61798e0001"
    sha256 cellar: :any,                 arm64_ventura:  "9a54fbbd61ff1dcdc7221a38581820694c2e12ac1a151cd98f95a050f46b315a"
    sha256 cellar: :any,                 arm64_monterey: "c00d5a24a8a98961f1cad0657cd68bd426dd84a2a31dcde70b9d5c73837bc51b"
    sha256 cellar: :any,                 sonoma:         "f2d4b7818352d243ca2bfed29bc00b1f7844cb70cda75ffdccd2cf007e263c2f"
    sha256 cellar: :any,                 ventura:        "b44516bd993e77c6772be3645b05252956d4cf4f126e135d2c5a0082ae00a432"
    sha256 cellar: :any,                 monterey:       "117aad92a8af1f06e070fc3d3e6c28423419215fd4ffb8fe019cc9ad91b1cbcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fd56f3d210b17135462fc4b97d9927d7b8805ccd007bc840444a911c38ac85e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "liblo"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "mapper/mapper.h"
      int main() {
        printf("%s", mpr_get_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmapper", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
