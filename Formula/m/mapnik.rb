class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.0.0",
      revision: "85801bd4028fa1cbffd9f7de4e2458bfc55e44bd"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8b70e858715271ea57910edb147cf52bcfb5d41e28056e91eb2ddfe2b916b470"
    sha256 cellar: :any,                 arm64_ventura:  "276a500cbd99981a1cc240f023b0f8a7265bdf92caa0b2c3342c8ecdbe630f0a"
    sha256 cellar: :any,                 arm64_monterey: "73953b83a7dce9bae6e6ddfeaf109ab4c93601c3564d2249c9649eb998963023"
    sha256 cellar: :any,                 sonoma:         "60df6eb48932bf4502cd7837639f542b8f1050e8d9997baa54c8ecd592af100b"
    sha256 cellar: :any,                 ventura:        "c1004613b0b7d554a57270509d664d1fbc55a65401b6f7bec1f59f671bc299a0"
    sha256 cellar: :any,                 monterey:       "c645d88bde9888ae6954b11b6dec8f060edad97b6b901ccf830cd83b7fe636bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "689925341a4ef8a29cf1eb7a6c18ec1a177da427c831da77fd0646330de244a7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "webp"

  uses_from_macos "zlib"

  fails_with :gcc do
    version "14"
    cause "Fails to build with GCC 14 (https://github.com/mapnik/mapnik/pull/4456)"
  end

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_BENCHMARK:BOOL=OFF"
    cmake_args << "-DBUILD_DEMO_CPP:BOOL=OFF"
    cmake_args << "-DBUILD_DEMO_VIEWER:BOOL=OFF"
    cmake_args << "-DCMAKE_INSTALL_RPATH:PATH=#{rpath}"

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["pkg-config"].bin}/pkg-config libmapnik --variable prefix").chomp
    assert_equal prefix.to_s, output

    output = shell_output("#{bin}/mapnik-index --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output

    output = shell_output("#{bin}/mapnik-render --version 2>&1", 1).chomp
    assert_equal "version #{stable.version}", output
  end
end
