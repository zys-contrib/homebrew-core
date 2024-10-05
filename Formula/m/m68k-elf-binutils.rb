class M68kElfBinutils < Formula
  desc "GNU Binutils for m68k-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.1.tar.bz2"
  sha256 "becaac5d295e037587b63a42fad57fe3d9d7b83f478eb24b67f9eec5d0f1872f"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  depends_on "pkg-config" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "m68k-elf"
    system "./configure", "--target=#{target}",
           "--prefix=#{prefix}",
           "--libdir=#{lib}/#{target}",
           "--infodir=#{info}/#{target}",
           "--with-system-zlib",
           "--with-zstd",
           "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~EOS
      .section .text
      .globl _start
      _start:
          move.b #42, d0
          move.b #42, d1
    EOS

    system bin/"m68k-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-m68k",
                 shell_output("#{bin}/m68k-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/m68k-elf-c++filt _Z1fv")
  end
end
