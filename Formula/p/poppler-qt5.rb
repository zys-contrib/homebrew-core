class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-24.11.0.tar.xz"
  sha256 "7723d880565211740c13649d24a300257b86ddd7fa2d208187ff7e5cc8dfbd58"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_sequoia:  "8b5a420c83516ddfe6148a1b63b3016e1c6684a3ca7dc3599e8a639b8f2f7d09"
    sha256 arm64_sonoma:   "68c70a13741b87792902219a6ba666354f4fdbbc7838a07f271ac77140d82fd1"
    sha256 arm64_ventura:  "637369aae5fead971b1538a7a32d24f46fb9a44c63fb6125e97f2446e2e6f2f2"
    sha256 arm64_monterey: "fcb94b326dd715acc439f3a152e14e50765d9a6867224f75f55c3ac2fdaf5c12"
    sha256 sonoma:         "8787f6c0ba49344cdd34326076456192dbfc0dbd1e7644d6577a5b4cb13dd188"
    sha256 ventura:        "ba9b7e9780e37c0c77fa370b981206c47a2d440055d065a16a0928b233fa93ec"
    sha256 monterey:       "97e1ada0094dd0805b385f6698286f346740ae88b99cf526e6505e62c80bdb59"
    sha256 x86_64_linux:   "1b22d0fd6dacf9bff211a3d31b265dc543be80ff8f7bd3860fed52ebaba508e9"
  end

  keg_only "it conflicts with poppler"

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gpgme"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "nspr"
  depends_on "nss"
  depends_on "openjpeg"
  depends_on "qt@5"

  uses_from_macos "gperf" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libassuan"
  end

  fails_with gcc: "5"

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.12.tar.gz"
    sha256 "c835b640a40ce357e1b83666aabd95edffa24ddddd49b8daff63adb851cdab74"
  end

  def install
    ENV.cxx11

    args = std_cmake_args + %W[
      -DBUILD_GTK_TESTS=OFF
      -DENABLE_BOOST=OFF
      -DENABLE_CMS=lcms2
      -DENABLE_GLIB=ON
      -DENABLE_QT5=ON
      -DENABLE_QT6=OFF
      -DENABLE_UNSTABLE_API_ABI_HEADERS=ON
      -DWITH_GObjectIntrospection=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build_shared", *args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build_static"
    lib.install "build_static/libpoppler.a"
    lib.install "build_static/cpp/libpoppler-cpp.a"
    lib.install "build_static/glib/libpoppler-glib.a"

    resource("font-data").stage do
      system "make", "install", "prefix=#{prefix}"
    end
  end

  test do
    system bin/"pdfinfo", test_fixtures("test.pdf")
  end
end
