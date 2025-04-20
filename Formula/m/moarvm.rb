class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2025.04/MoarVM-2025.04.tar.gz"
  sha256 "71c44dce2d3d6630959a3ffd95e5bb456433426635217f1a77efde152c11109c"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "0f016006c44fc685fe910b330cf2b62b5904f5187e838ab6288d1ef0ca217a54"
    sha256 arm64_sonoma:  "6b40a21f8c21359ece5c40efe52c5d3306dc354fcce6b35b6ebfcd189c180a7b"
    sha256 arm64_ventura: "2d56e4288e19b3d73c6f4acfff52ef38d75f49aa471f4d103f5bc51c5d05d719"
    sha256 sonoma:        "c6e091534e4d75b3fcd2de7d7ad024129f808b16d497270421b617ebf6cf89af"
    sha256 ventura:       "c18204f1023270e7cf267b3b4ecac5f273a68b49d851b99a2a4a46656f283aa9"
    sha256 arm64_linux:   "2bdd1129e8a73573336be66302124b7a6d4980e3f3ea37e3fa4547c76b2be4e9"
    sha256 x86_64_linux:  "8ff588a13fda86b5399a0c1a9790645ece11782afbb6409bbc92a1170d9543d5"
  end

  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "mimalloc"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  on_macos do
    depends_on "libuv"
  end

  conflicts_with "moar", because: "both install `moar` binaries"
  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2025.04/nqp-2025.04.tar.gz"
    sha256 "6468566fd63a75b743979df433beab99690125c4d90972c3b371f6ace82528a0"
  end

  def install
    # Remove bundled libraries
    %w[dyncall libatomicops libtommath mimalloc].each { |dir| rm_r("3rdparty/#{dir}") }

    configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-mimalloc
      --optimize
      --pkgconfig=#{Formula["pkgconf"].opt_bin}/pkgconf
      --prefix=#{prefix}
    ]
    # FIXME: brew `libuv` causes runtime failures on Linux, e.g.
    # "Cannot find method 'made' on object of type NQPMu"
    if OS.mac?
      configure_args << "--has-libuv"
      rm_r("3rdparty/libuv")
    end

    system "perl", "Configure.pl", *configure_args
    system "make", "realclean"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("nqp")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
