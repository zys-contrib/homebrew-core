class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  # needs submodules
  url "https://github.com/mapnik/mapnik.git",
      tag:      "v4.0.3",
      revision: "e7a2bacb5d70f9c5fe0941906ce19137c0928522"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5583a6c0c16d12a2a7dbe3ca979f954dfec1500ff6bf23e9af70271b961584b4"
    sha256 cellar: :any,                 arm64_sonoma:  "38a345b5ba53e9e6b3b20ec8646ac0f43a2564c4268d9ad59baeebc01fbc7476"
    sha256 cellar: :any,                 arm64_ventura: "94c70788a5b604e1b54cbb302580b32237f4d8856b4e4e31d4043b40e80c3b09"
    sha256 cellar: :any,                 sonoma:        "1c712e51ba20141f9f8effd91434626e4c909ab700d14c4fcdda21553713ca19"
    sha256 cellar: :any,                 ventura:       "3c0d132307ae32bdf3d89003a8196d6262bb2e07c3ecef64204f9048e4d38cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a08d06d4187900ce9f98eb3c1178b3d26ee6294539e0010f4c78a50b24d4f467"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c@76"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "webp"

  uses_from_macos "zlib"

  conflicts_with "osrm-backend", because: "both install Mapbox Variant headers"
  conflicts_with "svg2png", because: "both install `svg2png` binaries"

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
