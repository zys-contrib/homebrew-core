class Asm6809 < Formula
  desc "Cross assembler targeting the Motorola 6809 and Hitachi 6309"
  homepage "https://www.6809.org.uk/asm6809/"
  url "https://www.6809.org.uk/asm6809/dl/asm6809-2.13.tar.gz"
  sha256 "1a5caa2ab411d6f0bdcb97004f7aa2b7f3ade0b7a281a2322380ff9fe116c6cb"
  license "GPL-3.0-or-later"

  head do
    url "https://www.6809.org.uk/git/asm6809.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    input = testpath/"a.asm"

    input.write <<~EOS
      ; Instructions must be preceeded by whitespace
        org $c000
        lda $42
        end $c000
    EOS

    output = testpath/"a.bin"

    system bin/"asm6809", input, "-o", output
    binary = output.binread.unpack("C*")
    assert_equal [0xb6, 0x00, 0x42], binary
  end
end
