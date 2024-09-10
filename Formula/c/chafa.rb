class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.14.3.tar.xz"
  sha256 "f3d5530a96c8e55eea180448896e973093e0302f4cbde45d028179af8cfd90f3"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fcc526a43c32c12ad8a4df21f6b0323366a4db9d6e5049ea7839a8d8503d7495"
    sha256 cellar: :any,                 arm64_ventura:  "9f79a9d69949a515ac6b1b830352f1872c7189f2993d5583d80265ef91015b5c"
    sha256 cellar: :any,                 arm64_monterey: "2ee2a6926f235739d640a73242b5a72b42ad1658ba6d47b96620be18410e0664"
    sha256 cellar: :any,                 sonoma:         "d99204ccf5286cce6d88b0d65b66e3e722681fc765896d319c46d2f42818d09f"
    sha256 cellar: :any,                 ventura:        "106fa3941f6150a3e70dbf927e91c6b858b56dd209cc2088320a7e8963dbe32b"
    sha256 cellar: :any,                 monterey:       "2f98014f0b6baaa0bcbaac2764a9b2ac1b77955e75903d0b16e44d4657fcabce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3981762ae579cc734ba2b4a42f294dff7ab27bfd6ebe9d3e87298339ec841f1e"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "webp"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    man1.install "docs/chafa.1"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 3, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* JPEG.* SVG.* TIFF.* WebP/, output)
  end
end
