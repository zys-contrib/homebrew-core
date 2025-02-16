class Freebayes < Formula
  desc "Bayesian haplotype-based genetic polymorphism discovery and genotyping"
  homepage "https://github.com/freebayes/freebayes"
  # pull from git tag to get submodules
  url "https://github.com/freebayes/freebayes.git",
      tag:      "v1.3.9",
      revision: "ab36d1f789c039ba872f5d911ce6ff09952dc329"
  license "MIT"
  head "https://github.com/freebayes/freebayes.git", branch: "master"

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
    sha256 cellar: :any, arm64_sequoia: "42919ea368e7fb300680e17b7eb783e61eaa251c8b1492d2eba3e9db068bf3e8"
    sha256 cellar: :any, arm64_sonoma:  "c367f0574466d1c538750aeed89d68b2066280be424fbfdd8f33f92ae6f3e538"
    sha256 cellar: :any, arm64_ventura: "58b47ea65fc8b8fd2bcedad4b67e9edb1f41781679ddbd2f2d7d214a1e3eaabc"
    sha256 cellar: :any, sonoma:        "d6c0009f7ed19acbfe3d93a83fe4a1ec6d1c21867f67ad037bfda62c56394122"
    sha256 cellar: :any, ventura:       "b2631095db533474d1e6ce81dc00412cbf2c378bcd9cec40959b029aa8e9a8f4"
    sha256               x86_64_linux:  "056ef004633b4ad83902199054e990313f0e2654455ebe17f822b28d5a7add9a"
  end

  depends_on "cmake" => :build # for vcflib
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build # for vcflib
  depends_on "simde" => :build
  depends_on "wfa2-lib" => :build # for vcflib
  depends_on "xz" => :build # for vcflib
  depends_on "htslib"

  uses_from_macos "bzip2" => :build # for vcflib
  uses_from_macos "zlib" => :build # for vcflib

  on_macos do
    depends_on "libomp" => :build # for vcflib
  end

  resource "vcflib" do
    url "https://github.com/vcflib/vcflib/releases/download/v1.0.12/vcflib-1.0.12-src.tar.gz"
    sha256 "cb1e78d675f06ae3b22ffed7e1dea317e4c7f826e51e5b5dabd80240efbe1019"

    # Backport fix for using external `wfa2-lib`
    patch do
      url "https://github.com/vcflib/vcflib/commit/5e4edec2fba5d5a51dae7a9fe48d0252ade53857.patch?full_index=1"
      sha256 "e7d6d433d837dd823916ef91fe0165bf4ba4f05c52fd4c9517aef7f80653a2a8"
    end

    # Apply open PR to help find `wfa2-lib` include directory
    # PR ref: https://github.com/vcflib/vcflib/pull/413
    patch do
      url "https://github.com/vcflib/vcflib/commit/9f9237ff0e6b4887f0edfc88587957aa736ced7b.patch?full_index=1"
      sha256 "bede43d22b4b47141cd90edc4df90f65b9ac41e9598c2b05b2fe7fa84ea51aa8"
    end
  end

  # Apply open PR to help Meson locate vcflib and wfa2 libraries
  # PR ref: https://github.com/freebayes/freebayes/pull/822
  patch do
    url "https://github.com/freebayes/freebayes/commit/b458396e1acbad3983c70c202a6db2b3711a8eac.patch?full_index=1"
    sha256 "b5c7d855d4d66c6c96dada307e82ccbf0b6904a25928c4f3e163f52e178b7907"
  end

  # Apply open PR to fix build when using git submodules
  # PR ref: https://github.com/freebayes/freebayes/pull/823
  patch do
    url "https://github.com/freebayes/freebayes/commit/35eeacb6468fdce25233a33f7216f4e776d381f9.patch?full_index=1"
    sha256 "1b6f0bb1e369a4b11e9a7754f3b789035b39cc5d9e3dbbac84fde21893f0d9be"
  end

  def install
    resource("vcflib").stage do
      rm_r(["contrib/WFA2-lib", "contrib/tabixpp/htslib"]) # avoid bundled libraries

      system "cmake", "-S", ".", "-B", "build",
                      "-DBUILD_DOC=OFF",
                      "-DBUILD_ONLY_LIB=ON",
                      "-DZIG=OFF",
                      *std_cmake_args(install_prefix: buildpath/"vendor")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      system "make", "-C", "contrib/intervaltree", "install", "DESTDIR=", "PREFIX=#{buildpath}/vendor"
      (buildpath/"vendor/include").install "contrib/tabixpp/tabix.hpp"

      ENV.append_path "LIBRARY_PATH", buildpath/"vendor/bin"
      ENV.append_to_cflags "-I#{buildpath}/vendor/include"
      ENV.append_to_cflags "-I#{buildpath}/vendor/include/vcflib"
    end

    # Set prefer_system_deps=false as we don't have formulae for these and some are not versioned/tagged
    system "meson", "setup", "build", "-Dcpp_std=c++14", "-Dprefer_system_deps=false", *std_meson_args
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
