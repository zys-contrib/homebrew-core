class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/archive/refs/tags/v4.13.0.tar.gz"
  sha256 "647a5094ca968dee799331c5dc30e153076c36fc21303f1c0221a91bce429123"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3eeed36c9e2ef2d4bc6c01e4fa6da3a4e39c033a9f86cbc20b16a91006f7116"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecb348c40d1a56d69b34bd6002c0bcdf47ef7b297bb47205bac8cffded489847"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e75b670fa4ea9a85ba775e815540487ae886110dc111e6cc8646235829fc9cdf"
    sha256 cellar: :any_skip_relocation, sonoma:         "6283fe6740cf30b25386bab5ad3555809dd51639530eaafb9ae7ad60a173e335"
    sha256 cellar: :any_skip_relocation, ventura:        "71ea4eb853a9e2a08ed061a5fcd5daf4b9c60f6c77b7a81530067c6e92b59923"
    sha256 cellar: :any_skip_relocation, monterey:       "85239f25e69bbb2b221a81915621cef0bad9adbedeace28c4b59588c54596b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2044043f083dd1190cd08a45b0f3f1b6498a8939d4491465e90f3a51d016cf6"
  end

  depends_on "fftw"
  depends_on "gcc"
  depends_on "openblas"

  on_linux do
    depends_on "libtool" => :build
  end

  def install
    system "make", "fortran"
    system "make", "fortran-mp"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp_r "#{share}/examples/shtools", testpath
    system "make", "-C", "shtools/fortran",
                   "run-fortran-tests-no-timing",
                   "F95=gfortran",
                   "F95FLAGS=-m64 -fPIC -O3 -std=gnu -ffast-math",
                   "MODFLAG=-I#{HOMEBREW_PREFIX}/include",
                   "LIBPATH=#{HOMEBREW_PREFIX}/lib",
                   "LIBNAME=SHTOOLS",
                   "FFTW=-L #{HOMEBREW_PREFIX}/lib -lfftw3 -lm",
                   "LAPACK=-L #{Formula["openblas"].opt_lib} -lopenblas",
                   "BLAS="
  end
end
