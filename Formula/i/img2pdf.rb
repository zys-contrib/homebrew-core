class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/82/c3/023387e00682dc1b46bd719ec19c4c9206dc8eb182dfd02bc62c5b9320a2/img2pdf-0.6.1.tar.gz"
  sha256 "306e279eb832bc159d7d6294b697a9fbd11b4be1f799b14b3b2174fb506af289"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5ebd58206276d9220b4e2b458befe3868ab5d7ed2d177316242fdc1facb2daa"
    sha256 cellar: :any,                 arm64_sonoma:  "90b252551ff71588ebdfcb59807a44c29d0f6a50e77b6beb8e66be6cb9bef8d7"
    sha256 cellar: :any,                 arm64_ventura: "8c4928259d71cd47b7a1ad76f4cfcd433efcd40fc78a74004bd9de958b3c1601"
    sha256 cellar: :any,                 sonoma:        "73a809ba81e45f22251450ae5f7b9d1a998ca95c5906154e21e33706265447ae"
    sha256 cellar: :any,                 ventura:       "79f3d0152ffb4d461166ae20ddacf08b84f7630eb36ad1cf0875fbb8bab91cab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8257aca4a22a7abc29ebbef06a186902624e0f61f674c36d3dc2743c182f25f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f0d501f933a9c6d8c02c415e0c3c7931f6c301ff3d30ff4bda7f1910100e153"
  end

  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "qpdf"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/9d/eb/4756ba366b5b243a1b5711e02993ea932d45d7e2d750bf01eb0029dc443e/pikepdf-9.7.0.tar.gz"
    sha256 "ab54895a246768a2660cafe48052dbf5425c76f6f04e0f53b911df6cfd7e1c95"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"img2pdf", test_fixtures("test.png"), test_fixtures("test.jpg"),
                             test_fixtures("test.tiff"), "--pagesize", "A4", "-o", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
