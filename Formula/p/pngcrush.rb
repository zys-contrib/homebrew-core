class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "https://pmt.sourceforge.io/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.13/pngcrush-1.8.13-nolib.tar.xz"
  sha256 "3b4eac8c5c69fe0894ad63534acedf6375b420f7038f7fc003346dd352618350"
  # The license is similar to "Zlib" license with clauses phrased like
  # the "Libpng" license section for libpng version 0.5 through 0.88.
  license :cannot_represent

  livecheck do
    url :stable
    regex(%r{url=.*?/pngcrush[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54e662b489d12b53c1b219a1549fa3a638a040cec91550862c95a3fee1b50480"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abcad2b9692fd0f7346bfa30d8c9fce599af8ddf5270095430955cfd4e20b55c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "159bb125480ec4ac71bac11766ed999350c63304c2549df0898e2bbb07b4aa24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba3aa0d156954d41cb43b96bd5529c3a68e56a67a751b3a9cc153e3ed47e2425"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2824b444fbdf43c4b54a28e383e6d02c60bf7a97948903d535a6a79d834b2be"
    sha256 cellar: :any_skip_relocation, ventura:        "9eca82828051b434711878c5abc8cd89350c370bfa8b108eef177f4aa4566703"
    sha256 cellar: :any_skip_relocation, monterey:       "f2d01a0b536d81a1db9b094f8cc282e16cfd4a218880b1d12cce67423d5865e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f7a3810130d10dc7b448aeb8c53cf8b52da9312863ff12edeb3c1268eaf6ea6"
    sha256 cellar: :any_skip_relocation, catalina:       "f6b31e35011fd69dc4ee678e4529fd5a76ee7be8faba88bb7c9cb0b7cbfafacb"
    sha256 cellar: :any_skip_relocation, mojave:         "904e958b1198e2931ab233981764b1ec66b26da793445c0fa10182588b5369a7"
    sha256 cellar: :any_skip_relocation, high_sierra:    "db13f642eae1815e00e1a80d363228e0311d85ca510e9c9de94dba8483fa2d87"
    sha256 cellar: :any_skip_relocation, sierra:         "f648ad0c664699f67bba8ba791358e8b294d0c1d975f026aa67fc1635badbc73"
    sha256 cellar: :any_skip_relocation, el_capitan:     "2633aff1e7cec8bb6c55da5c4daf9f555c74e516ebcc5f3027589588f76d3e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "113b32d47a907b6d52c02bcb079f0d08b066731db671076c54353888288b6142"
  end

  depends_on "libpng"

  uses_from_macos "zlib"

  # Use Debian's patch to fix build with `libpng`.
  # Issue ref: https://sourceforge.net/p/pmt/bugs/82/
  patch do
    url "https://sources.debian.org/data/main/p/pngcrush/1.8.13-1/debian/patches/ignore_PNG_IGNORE_ADLER32.patch"
    sha256 "d1794d1ffef25a1c974caa219d7e33c0aa94f98c572170ec12285298d0216c29"
  end

  def install
    zlib = OS.mac? ? "#{MacOS.sdk_path_if_needed}/usr" : Formula["zlib"].opt_prefix
    args = %W[
      CC=#{ENV.cc}
      LD=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      PNGINC=#{Formula["libpng"].opt_include}
      PNGLIB=#{Formula["libpng"].opt_lib}
      ZINC=#{zlib}/include
      ZLIB=#{zlib}/lib
    ]
    system "make", *args
    bin.install "pngcrush"
  end

  test do
    system bin/"pngcrush", test_fixtures("test.png"), "/dev/null"
  end
end
