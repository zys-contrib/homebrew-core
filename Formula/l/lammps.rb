class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://docs.lammps.org/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_29Aug2024_update2.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20240829-update2"
  sha256 "f8ca3f021a819ced8658055f7750e235c51b4937ddb621cf1bd7bee08e0b6266"
  license "GPL-2.0-only"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYY-MM-DD format we use in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(/^stable[._-](\d{1,2}\w+\d{2,4})(?:[._-](update\d*))?$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        match = tag.match(regex)
        next if match.blank? || match[1].blank?

        date_str = Date.parse(match[1]).strftime("%Y%m%d")
        match[2].present? ? "#{date_str}-#{match[2]}" : date_str
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89227eb8b499dbe9ba095bddba0801dda8a613e5f6872028b8c51e1f035ee87f"
    sha256 cellar: :any,                 arm64_sonoma:  "465ccc4bcc1caf691fcf0df4f01acef665cd9e09dec5f6d6e891631afc7248cd"
    sha256 cellar: :any,                 arm64_ventura: "1fa9cbca449a1efafdbc3dc8cc88c8089287fa5da226f1c7e414e536fe333ab5"
    sha256 cellar: :any,                 sonoma:        "ad2879b677bcdb3713a8c1b97a29129b8608eada959fa45ec743262635c4a795"
    sha256 cellar: :any,                 ventura:       "fb6d882f046e167118ff064db3e0bc8d4a164a3664d55c8f179150acdb19eceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77ef1b3d53e70864197aaba1b3001abd15b756dacb0fea3359c8d916d4fd8528"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "kim-api"
  depends_on "libpng"
  depends_on "open-mpi"
  depends_on "voro++"

  uses_from_macos "curl"

  on_macos do
    depends_on "libomp"
  end

  def install
    %w[serial mpi].each do |variant|
      args = [
        "-S", "cmake", "-B", "build_#{variant}",
        "-C", "cmake/presets/all_on.cmake",
        "-C", "cmake/presets/nolib.cmake",
        "-DPKG_INTEL=no",
        "-DPKG_KIM=yes",
        "-DPKG_VORONOI=yes",
        "-DLAMMPS_MACHINE=#{variant}",
        "-DBUILD_MPI=#{(variant == "mpi") ? "yes" : "no"}",
        "-DBUILD_OMP=#{(variant == "serial") ? "no" : "yes"}",
        "-DBUILD_SHARED_LIBS=yes",
        "-DFFT=FFTW3",
        "-DWITH_GZIP=yes",
        "-DWITH_JPEG=yes",
        "-DWITH_PNG=yes",
        "-DCMAKE_INSTALL_RPATH=#{rpath}"
      ]
      args << "-DOpenMP_CXX_FLAGS=-I#{Formula["libomp"].opt_include}" if OS.mac?
      system "cmake", *args, *std_cmake_args
      system "cmake", "--build", "build_#{variant}"
      system "cmake", "--install", "build_#{variant}"
    end

    pkgshare.install %w[doc tools bench examples]
  end

  test do
    system bin/"lmp_serial", "-in", pkgshare/"bench/in.lj"
    output = shell_output("#{bin}/lmp_serial -h")
    %w[KSPACE POEMS VORONOI].each do |pkg|
      assert_match pkg, output
    end
  end
end
