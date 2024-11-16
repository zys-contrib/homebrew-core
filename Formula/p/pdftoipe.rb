class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "83ed62435778f3458488df273547f0b62affc8e0639f277f7b696ab65af7db42"
    sha256 cellar: :any,                 arm64_sonoma:   "3ffc098642fb07f56fdf7123d1ed96e89c08e2a90138fe14b75fbaa5fb1a0baa"
    sha256 cellar: :any,                 arm64_ventura:  "abaf4114b8f8e31cf552dedf510267915baea3cfac66eee9881c9ed357a0f1a5"
    sha256 cellar: :any,                 arm64_monterey: "3d2e9878726033261d5d28a7cfe217f9eab8bc25ca87c62396043a4dd565a5f9"
    sha256 cellar: :any,                 sonoma:         "da1ac14a407e12800983b7964d1e9c8568704cf1cda25c2537b1d33f730fc831"
    sha256 cellar: :any,                 ventura:        "fcec35e3b168b6bd8c83a8dda6d9b1464d5bdb1e326b649463567f9b05b03937"
    sha256 cellar: :any,                 monterey:       "cea74fc81e5544544e9e8534c97a3b7987f16b9ed7859e9a7c8fa7318649bc47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a3da5c3168fefc7e7899400b3a618b91072777ed35feed3b76a727a3d99964c"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  fails_with gcc: "5"

  def install
    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end
