class Jbig2enc < Formula
  desc "JBIG2 encoder (for monochrome documents)"
  homepage "https://github.com/agl/jbig2enc"
  url "https://github.com/agl/jbig2enc/archive/refs/tags/0.30.tar.gz"
  sha256 "4468442f666edc2cc4d38b11cde2123071a94edc3b403ebe60eb20ea3b2cc67b"
  license "Apache-2.0"
  head "https://github.com/agl/jbig2enc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e56a40c42b91521dc85adbd0e64f139996cf651ccf20566791eb025562b5c989"
    sha256 cellar: :any,                 arm64_sonoma:   "b7e975bf348576e5e3aa681fc09c15b91f4cf7542b071027fb277e35d2f09e84"
    sha256 cellar: :any,                 arm64_ventura:  "5894ec7327cf835d5c03aa7dfe077ec1976e07587fe3f7f8a8d188b07d486dda"
    sha256 cellar: :any,                 arm64_monterey: "a616b755cbdaf4d7133f6a7dde4a1a8cf59295bf627b00a3a6f022e2c0b2010f"
    sha256 cellar: :any,                 arm64_big_sur:  "c4fd2fd1394266163c8e07b4378c09ddd57c408c3fdf8098b7c0931856c3e742"
    sha256 cellar: :any,                 sonoma:         "371b2cf59f44ff4d8a964095c5a1ba7f9883847576d2ee18d53ae0621e3e1ee4"
    sha256 cellar: :any,                 ventura:        "1e3b10797b108104ededfbdada4f6c03d288dbc3f4c2b75173d29796e53edac7"
    sha256 cellar: :any,                 monterey:       "fbf2dcb1e29ac4aff73463dd153d38357b073b9ab184001d6a9a4baabd44023d"
    sha256 cellar: :any,                 big_sur:        "9cc450a97ea92e1b86cc68b4b521971de0f3816939b495fa9ca8ac5b8d66c7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de11ca25b4e186c650ecf95a3711f6cb8ae605b52054553c3b1814f0aabca269"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "leptonica"

  on_macos do
    depends_on "giflib"
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libtiff"
    depends_on "webp"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/jbig2 -s -S -p -v -O out.png #{test_fixtures("test.jpg")} 2>&1")
    assert_match "no graphics found in input image", output
    assert_path_exists testpath/"out.png"
  end
end
