class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.13.3/nvc-1.13.3.tar.gz"
  sha256 "c657d052d8a1eeba2dd97e92330c676de0a6d4d4c2eedea25adec64405dd87c7"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "08fa9f03d8810538b606b3034af3a5d75c0b63fdf74012a988853855cd14e97c"
    sha256 arm64_sonoma:  "ee18f66a3b35904dac2c03b62a8c4bdca3a88a5b4ae8fa4915ebe45a2be7e3e2"
    sha256 arm64_ventura: "5b016ebed4c3cb1a80a7eb90e8847a3a6c6ca064b181349995193f5fde3a017d"
    sha256 sonoma:        "1bca86f99266a1399192231a8281a886ec6f808eafc5eb7664711de3cd42549f"
    sha256 ventura:       "85cfbee02c6aaf4dcd1737f11733eddb7628593697ad2f4bc6026720c5ca2a59"
    sha256 x86_64_linux:  "84234d0ee6a2d94ace7d97c0ac65cdcf6bb927bd49eed8c9c014d85d327fc556"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    system "./autogen.sh" if build.head?

    # Avoid hardcoding path to the `ld` shim.
    ENV["ac_cv_path_linker_path"] = "ld" if OS.linux?

    # In-tree builds are not supported.
    mkdir "build" do
      system "../configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                             "--prefix=#{prefix}",
                             "--with-system-cc=#{ENV.cc}",
                             "--disable-silent-rules"
      inreplace ["Makefile", "config.h"], Superenv.shims_path/ENV.cc, ENV.cc
      ENV.deparallelize
      system "make", "V=1"
      system "make", "V=1", "install"
    end

    (pkgshare/"examples").install "test/regress/wait1.vhd"
  end

  test do
    resource "homebrew-test" do
      url "https://raw.githubusercontent.com/suoto/vim-hdl-examples/fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b/basic_library/very_common_pkg.vhd"
      sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
    end

    testpath.install resource("homebrew-test")
    system bin/"nvc", "-a", testpath/"very_common_pkg.vhd"
    system bin/"nvc", "-a", pkgshare/"examples/wait1.vhd", "-e", "wait1", "-r"
  end
end
