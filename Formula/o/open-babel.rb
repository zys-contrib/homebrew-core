class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://github.com/openbabel/openbabel"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/openbabel/openbabel.git", branch: "master"

  stable do
    url "https://github.com/openbabel/openbabel/releases/download/openbabel-3-1-1/openbabel-3.1.1-source.tar.bz2"
    sha256 "a6ec8381d59ea32a4b241c8b1fbd799acb52be94ab64cdbd72506fb4e2270e68"

    # Backport support for configuring PYTHON_INSTDIR to avoid Setuptools
    patch do
      url "https://github.com/openbabel/openbabel/commit/f7910915c904a18ac1bdc209b2dc9deeb92f7db3.patch?full_index=1"
      sha256 "f100bb9bffb82b318624933ddc0027eeee8546bf4d6deda5067ecbd1ebd138ea"
    end
  end

  bottle do
    rebuild 2
    sha256 arm64_sequoia:  "2c59d7db4305c267949fba8d6aea3ae90a84bc65a649af40d067dab7f9ce1ea7"
    sha256 arm64_sonoma:   "f419ccc5548f2ef7476cf80f63a9202026a342955ab6636b52defa8ff4a49613"
    sha256 arm64_ventura:  "3897a0b1768ca3e0037070cb17890ca83ad9e5ac165832c97b5b3b25c4077164"
    sha256 arm64_monterey: "145b1a3f4d2d295f35bcec9e8698191caccc1798d478fc76563d7eb5301dd504"
    sha256 sonoma:         "cbf0992d5a6f648fc362d7c0e6a34ff4f36c4997d6220e8d0c6d2b784e5b4b14"
    sha256 ventura:        "ec8cb56581eaaf3cc1f39b31697ddf23898a9da5716aa6905aeeaca99a30caa1"
    sha256 monterey:       "dfee32016d8264bdddbceaf883e7997f12e5064ad7596b0dd898b0fd0e76a52d"
    sha256 x86_64_linux:   "7e950edb7779a9f98d7acee8aab9215fd3fa9fc64ab57b64fe2a2f37940d72bc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build

  depends_on "cairo"
  depends_on "eigen"
  depends_on "inchi"
  depends_on "python@3.12"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def python3
    "python3.12"
  end

  conflicts_with "surelog", because: "both install `roundtrip` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DINCHI_INCLUDE_DIR=#{Formula["inchi"].opt_include}/inchi",
                    "-DOPENBABEL_USE_SYSTEM_INCHI=ON",
                    "-DRUN_SWIG=ON",
                    "-DPYTHON_BINDINGS=ON",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DPYTHON_INSTDIR=#{prefix/Language::Python.site_packages(python3)}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}/obabel -:'C1=CC=CC=C1Br' -omol")

        7  7  0  0  0  0  0  0  0  0999 V2000
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 Br  0  0  0  0  0  0  0  0  0  0  0  0
        1  6  1  0  0  0  0
        1  2  2  0  0  0  0
        2  3  1  0  0  0  0
        3  4  2  0  0  0  0
        4  5  1  0  0  0  0
        5  6  2  0  0  0  0
        6  7  1  0  0  0  0
      M  END
    EOS

    system python3, "-c", "from openbabel import openbabel"
  end
end
