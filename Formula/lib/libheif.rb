class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.19.3/libheif-1.19.3.tar.gz"
  sha256 "1e6d3bb5216888a78fbbf5fd958cd3cf3b941aceb002d2a8d635f85cc59a8599"
  license "LGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "49ea2b6b26a9c6850bbd09c5478316a0533a99c2559af83658beb01da42df9b0"
    sha256 cellar: :any,                 arm64_sonoma:  "dc70477bb1daae813245cbab42474216aadb2384710fd45b1ef04557ae7e8010"
    sha256 cellar: :any,                 arm64_ventura: "7edaf722b52739c798f14be2d926bb5a44bbcca17ee442bef882469dfe1fc918"
    sha256 cellar: :any,                 sonoma:        "e4225e4404b37f238b38f5d6baaf19181b971826aef5cfad119412f63a99d358"
    sha256 cellar: :any,                 ventura:       "a01a8cdee32b9d024db53c5d037e7f6cea662bd41166095401c0fb075605551c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e31a49f56504d7f499793ae18e9d224326bd7555aa62af73cbc535e81819773"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "shared-mime-info"
  depends_on "webp"
  depends_on "x265"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_DAV1D=OFF
      -DWITH_GDK_PIXBUF=OFF
      -DWITH_RAV1E=OFF
      -DWITH_SvtEnc=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.heic"
    pkgshare.install "examples/example.avif"

    system "cmake", "-S", ".", "-B", "static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install "static/libheif/libheif.a"
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    output = "File contains 2 images"
    example = pkgshare/"example.heic"
    exout = testpath/"exampleheic.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleheic-1.jpg", :exist?
    assert_predicate testpath/"exampleheic-2.jpg", :exist?

    output = "File contains 1 image"
    example = pkgshare/"example.avif"
    exout = testpath/"exampleavif.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleavif.jpg", :exist?
  end
end
