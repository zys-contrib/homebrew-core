class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-16.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-16.2.tar.xz"
  sha256 "4002cb7f23f45c37c790536a13a720942ce4be0402d929c9085e92f10d480119"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sequoia: "40c9445990e50f46055a0538f1803b246701a882e6740af896d789cc7f1bd328"
    sha256 arm64_sonoma:  "8da4e750b4483692102f5ec3b365630f57a087d37b27c8a56f5669952ca923ac"
    sha256 arm64_ventura: "8c9a7760a391ae720c0cc576e4fb92fd88f91f1b1129a923a6983cff36ca49a8"
    sha256 sonoma:        "b92c1c95c1872453d4d20a800e9fd39cf5e0872f2fc63d921c5e9224e36ba35d"
    sha256 ventura:       "ae6a4fc8e7d8e14c0af677a55a00c7cf621d80f17e985fadca29fb7299fd9570"
    sha256 x86_64_linux:  "da73f347e389919605693884a55a353b236a895b657118203034222417317516"
  end

  depends_on "x86_64-elf-gcc" => :test

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.13"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "x86_64-elf"
    args = %W[
      --target=#{target}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --with-lzma
      --with-python=#{which("python3.13")}
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args, *std_configure_args
      ENV.deparallelize # Error: common/version.c-stamp.tmp: No such file or directory
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system Formula["x86_64-elf-gcc"].bin/"x86_64-elf-gcc", "-g", "-nostdlib", "test.c"

    output = shell_output("#{bin}/x86_64-elf-gdb -batch -ex 'info address _start' a.out")
    assert_match "Symbol \"_start\" is a function at address 0x", output
  end
end
