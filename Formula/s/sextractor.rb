class Sextractor < Formula
  desc "Extract catalogs of sources from astronomical images"
  homepage "https://github.com/astromatic/sextractor"
  url "https://github.com/astromatic/sextractor/archive/refs/tags/2.28.2.tar.gz"
  sha256 "d92c5214ea75b8a70214d7d7f6824207fc53861ec923ceb2cc574f2ec9effa94"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "19c492865d16d4f75a79ff7f5dba818ff508ae8759386bf9a9ae51bb975611e5"
    sha256 arm64_sonoma:  "04589ae159ff12dad16858c302bebbf00f24f81251e443a0946a1289b24217e4"
    sha256 arm64_ventura: "34dc39610a43c2c9e1b2d31e0c30ef728a9602c09eeefa4bbe8dc33362ed23e6"
    sha256 sonoma:        "865ac257113da143885f40e611bfbc1c6c4e9b106b089f86230dee77b36581fd"
    sha256 ventura:       "4d2ddd02ee25ce672990aa58156ce05d976807290ebd25a07ebe215fbfa27968"
    sha256 x86_64_linux:  "d0839ccc9e1c008463f6ef4a08856729b2e69a1fecd909c32674952046877804"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "openblas"

  def install
    openblas = Formula["openblas"]
    system "./autogen.sh"
    system "./configure", *std_configure_args,
           "--disable-silent-rules",
           "--enable-openblas",
           "--with-openblas-libdir=#{openblas.lib}",
           "--with-openblas-incdir=#{openblas.include}"
    system "make", "install"
    # Remove references to Homebrew shims
    rm Dir["tests/Makefile*"]
    pkgshare.install "tests"
  end

  test do
    cp_r Dir[pkgshare/"tests/*"], testpath
    system bin/"sex", "galaxies.fits", "-WEIGHT_IMAGE", "galaxies.weight.fits", "-CATALOG_NAME", "galaxies.cat"
    assert_predicate testpath/"galaxies.cat", :exist?, "Failed to create galaxies.cat"
  end
end
