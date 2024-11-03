class Freebayes < Formula
  desc "Bayesian haplotype-based genetic polymorphism discovery and genotyping"
  homepage "https://github.com/freebayes/freebayes"
  license "MIT"
  head "https://github.com/freebayes/freebayes.git", branch: "master"

  stable do
    # Use tarball and resources as workaround for https://github.com/freebayes/freebayes/pull/799
    url "https://github.com/freebayes/freebayes/archive/refs/tags/v1.3.8.tar.gz"
    sha256 "d1c24b1d1b35277e7403cd67063557998218a105c916b01a745e7704715fce67"

    depends_on "cmake" => :build
    depends_on "pybind11" => :build
    depends_on "simde" => :build

    on_macos do
      depends_on "libomp" => :build
    end

    resource "contrib/smithwaterman" do
      url "https://github.com/ekg/smithwaterman/archive/2610e259611ae4cde8f03c72499d28f03f6d38a7.tar.gz"
      sha256 "8e1b37ab0e8cd9d3d5cbfdba80258c0ebd0862749b531e213f44cdfe2fc541d8"
    end

    resource "contrib/fastahack" do
      url "https://github.com/ekg/fastahack/archive/bb332654766c2177d6ec07941fe43facf8483b1d.tar.gz"
      sha256 "552a1b261ea90023de7048a27c53a425a1bc21c3fb172b3c8dc9f585f02f6c43"
    end

    resource "contrib/multichoose" do
      url "https://github.com/vcflib/multichoose/archive/255192edd49cfe36557f7f4f0d2d6ee1c702ffbb.tar.gz"
      sha256 "0045051ee85d36435582151830efe0eefb466be0ec9aedbbc4465dca30d22102"
    end

    resource "contrib/vcflib" do
      url "https://github.com/vcflib/vcflib.git",
          tag:      "v1.0.10",
          revision: "2ad261860807e66dbd9bcb07fee1af47b9930d70"
    end
  end

  # The Git repository contains a few older tags that erroneously omit a
  # leading zero in the version (e.g., `v9.9.2` should have been `v0.9.9.2`)
  # and these would appear as the newest versions until the current version
  # exceeds 9.9.2. `stable` uses a tarball from a release (not a tag archive),
  # so using the `GithubLatest` strategy is appropriate here overall.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "86e8ecdd554dd65c305d5c3a4a77199712a9135b0b3fb2c592ace85e725c4d11"
    sha256 cellar: :any, arm64_ventura:  "9f39d67a92d9e832723820b80cb4fa43ba7e2337887ef689fa43340424c77007"
    sha256 cellar: :any, arm64_monterey: "1d03d1fcb588e8e5f96d32c6ad511e46a61712d1a4521623f53ad8b9ded2727b"
    sha256 cellar: :any, sonoma:         "8faa87eff6dcab27a9799df3fb4abbfe7e137db29c6edac31fa91ff65b8d0a37"
    sha256 cellar: :any, ventura:        "dd99fa0c8d6c01e68341e49ff4c13e686661d7d2f33806b00be261f9284ade29"
    sha256 cellar: :any, monterey:       "4379827c288c32cc19ab7aa290b2f724254e3538d2f30288c5f1c3110aee705c"
    sha256               x86_64_linux:   "d2b3b2c133c9f59c8a29a77e5a60b933a63ae83c664b62ddd0802844623a9bc6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    if build.stable?
      resources.each { |r| (buildpath/r.name).install r }

      system "cmake", "-S", "contrib/vcflib", "-B", "build_vcflib",
                      "-DBUILD_DOC=OFF",
                      "-DBUILD_ONLY_LIB=ON",
                      "-DZIG=OFF",
                      *std_cmake_args(install_prefix: buildpath/"vendor")
      system "cmake", "--build", "build_vcflib"
      system "cmake", "--install", "build_vcflib"

      # libvcflib.a is installed into CMAKE_INSTALL_BINDIR
      (buildpath/"vendor/bin").install "build_vcflib/contrib/WFA2-lib/libwfa2.a"
      inreplace "meson.build" do |s|
        s.sub! "find_library('libvcflib'", "\\0, dirs: ['#{buildpath}/vendor/bin']"
        s.sub! "find_library('libwfa2'", "\\0, dirs: ['#{buildpath}/vendor/bin']"
      end
      ENV.append_to_cflags "-I#{buildpath}/vendor/include"
    end

    # Workaround for ../src/BedReader.h:12:10: fatal error: 'IntervalTree.h' file not found
    # Issue ref: https://github.com/freebayes/freebayes/issues/803
    ENV.append_to_cflags "-I#{buildpath}/contrib/SeqLib/SeqLib"

    system "meson", "setup", "build", "-Dcpp_std=c++14", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/tiny/.", testpath
    output = shell_output("#{bin}/freebayes -f q.fa NA12878.chr22.tiny.bam")
    assert_match "q\t186", output
  end
end
