class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/c2/62/c7402ffe11d43e88dbab6b7255f16743f8b9cbb3e7d3405f95a677a98c47/img2pdf-0.6.0.tar.gz"
  sha256 "85a89b8abdeef9ef033508aed0d9f1e84fd6d0130e864e2c523f948ec45365e1"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "f3573def2a29c6a218e73a9ede0e33222ae59faf67f52f07ea5f93565d21dcdd"
    sha256 cellar: :any,                 arm64_sonoma:  "b0cc3aae63f8605204f79569d7360efbcb809ff28a6695827becac78e3ab73bb"
    sha256 cellar: :any,                 arm64_ventura: "9be5bfeef8e77b9b41647b0689faaa179fde89ffbb933ef43cbb42359b43c7d8"
    sha256 cellar: :any,                 sonoma:        "af54a18cc25a6f45fbf3b3a6f66480947d4d5ca78ca811c3bb8e26d8117250a7"
    sha256 cellar: :any,                 ventura:       "20d68bf22e6b96a24e6eef9cdff3574f671d5b980fd1d0acca0f2a5e6a89f0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a21eb57faaafb20f42f19bdf1fc1fe733d9be1ca05963c3c42c5918e401b5c"
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
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/1c/2c/0707248e2bdfe148c53c43ea1a7fce730eab9ae8bbe65470720f5a7ddd25/pikepdf-9.5.2.tar.gz"
    sha256 "190b3bb4891a7a154315f505d7dcd557ef21e8130cea8b78eb9646f8d67072ed"
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
    assert_predicate testpath/"test.pdf", :exist?
  end
end
