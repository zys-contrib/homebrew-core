class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://github.com/cp2k/cp2k/releases/download/v2025.1/cp2k-2025.1.tar.bz2"
  sha256 "65c8ad5488897b0f995919b9fa77f2aba4b61677ba1e3c19bb093d5c08a8ce1d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "afcde06b0ad9e8670f2e03850a2683ef10338fc88c72999025256c2bdda6ed40"
    sha256 arm64_sonoma:  "e05d3c17c577b1532f32ea51a3b416630325a7d2d17a7bd272c28e06502a1424"
    sha256 arm64_ventura: "564589842cd32cca4030845add9c0ec5325db3d2ba84b72cc98b9936924c2cb5"
    sha256 sonoma:        "60fb71aa453096b23f0fe81d154e49f2c86c314eef8414123c5b3323f0e02e85"
    sha256 ventura:       "4c6a0bc4785229bdc7abe2a7c37aecb55e29a86a39ddf89adaf446e44c3050f6"
    sha256 x86_64_linux:  "3c59adfcd22bd261911dbf767a7b4321f933bd6bc3926278c751c46ea5c32d18"
  end

  depends_on "cmake" => :build
  depends_on "fypp" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "fftw"

  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"

  fails_with :clang # needs OpenMP support

  resource "libint" do
    url "https://github.com/cp2k/libint-cp2k/releases/download/v2.6.0/libint-v2.6.0-cp2k-lmax-5.tgz"
    sha256 "1cd72206afddb232bcf2179c6229fbf6e42e4ba8440e701e6aa57ff1e871e9db"
  end

  def install
    resource("libint").stage do
      system "./configure", "--enable-fortran", "--with-pic", *std_configure_args(prefix: libexec)
      system "make"
      ENV.deparallelize { system "make", "install" }
      ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    end

    # TODO: Remove dbcsr build along with corresponding CMAKE_PREFIX_PATH
    # and add -DCP2K_BUILD_DBCSR=ON once `cp2k` build supports this option.
    system "cmake", "-S", "exts/dbcsr", "-B", "build_psmp/dbcsr",
                    "-DWITH_EXAMPLES=OFF",
                    *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build_psmp/dbcsr"
    system "cmake", "--install", "build_psmp/dbcsr"
    # Need to build another copy for non-MPI variant.
    system "cmake", "-S", "exts/dbcsr", "-B", "build_ssmp/dbcsr",
                    "-DUSE_MPI=OFF",
                    "-DWITH_EXAMPLES=OFF",
                    *std_cmake_args(install_prefix: buildpath/"dbcsr")
    system "cmake", "--build", "build_ssmp/dbcsr"
    system "cmake", "--install", "build_ssmp/dbcsr"

    # Avoid trying to access /proc/self/statm on macOS
    ENV.append "FFLAGS", "-D__NO_STATM_ACCESS" if OS.mac?

    # Set -lstdc++ to allow gfortran to link libint
    cp2k_cmake_args = %w[
      -DCMAKE_SHARED_LINKER_FLAGS=-lstdc++
      -DCP2K_BLAS_VENDOR=OpenBLAS
      -DCP2K_USE_LIBINT2=ON
      -DCP2K_USE_LIBXC=ON
    ] + std_cmake_args

    system "cmake", "-S", ".", "-B", "build_psmp/cp2k",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_PREFIX_PATH=#{libexec}",
                    *cp2k_cmake_args
    system "cmake", "--build", "build_psmp/cp2k"
    system "cmake", "--install", "build_psmp/cp2k"

    # Only build the main executable for non-MPI variant as libs conflict.
    # Can consider shipping MPI and non-MPI variants as separate formulae
    # or removing one variant depending on usage.
    system "cmake", "-S", ".", "-B", "build_ssmp/cp2k",
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DCMAKE_PREFIX_PATH=#{buildpath}/dbcsr;#{libexec}",
                    "-DCP2K_USE_MPI=OFF",
                    *cp2k_cmake_args
    system "cmake", "--build", "build_ssmp/cp2k", "--target", "cp2k-bin"
    bin.install Dir["build_ssmp/cp2k/bin/*.ssmp"]

    (pkgshare/"tests").install "tests/Fist/water.inp"
  end

  test do
    system bin/"cp2k.ssmp", pkgshare/"tests/water.inp"
    system "mpirun", bin/"cp2k.psmp", pkgshare/"tests/water.inp"
  end
end
