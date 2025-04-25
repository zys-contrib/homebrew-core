class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects"
  homepage "https://fedorahosted.org/elfutils/"
  url "https://sourceware.org/elfutils/ftp/0.193/elfutils-0.193.tar.bz2"
  sha256 "7857f44b624f4d8d421df851aaae7b1402cfe6bcdd2d8049f15fc07d3dde7635"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-only"]

  livecheck do
    url "https://sourceware.org/elfutils/ftp/"
    regex(%r{href=(?:["']?v?(\d+(?:\.\d+)+)/?["' >]|.*?elfutils[._-]v?(\d+(?:\.\d+)+)\.t)}i)
  end

  bottle do
    sha256 arm64_linux:  "5d01777f15de91aec9bae428917d141c06857bd71ee5efb09b5ca2a97304830b"
    sha256 x86_64_linux: "38b483a6587bc278713cd61cf0d91482a4bb87175dd257640881c900809c8574"
  end

  depends_on "m4" => :build
  depends_on "pkgconf" => :build
  depends_on "bzip2"
  depends_on :linux
  depends_on "xz"
  depends_on "zlib"
  depends_on "zstd"

  def install
    system "./configure",
           *std_configure_args,
           "--disable-silent-rules",
           "--disable-libdebuginfod",
           "--disable-debuginfod",
           "--program-prefix=elfutils-",
           "--with-bzlib",
           "--with-lzma",
           "--with-zlib",
           "--with-zstd"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "elf_kind", shell_output("#{bin}/elfutils-nm #{bin}/elfutils-nm")
  end
end
