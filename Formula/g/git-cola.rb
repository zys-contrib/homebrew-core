class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/6b/34/fd3f893a2b58c8c51b22a3ea411d6f7040ba4816311b2befdfcc515e18b1/git-cola-4.8.0.tar.gz"
  sha256 "86971d6f386a70e1e7d35e8c2f57cd586cb81986ec8ca099cb93412142bbfbf0"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eedda9d6acb1387a846731597c17390857d0bc4eeb4534e2d45e5549b7f53878"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eedda9d6acb1387a846731597c17390857d0bc4eeb4534e2d45e5549b7f53878"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eedda9d6acb1387a846731597c17390857d0bc4eeb4534e2d45e5549b7f53878"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f8baf1e20b4e9f057fa0be7f49800a4c771844f2aa7d8711f0182326aa6d82a"
    sha256 cellar: :any_skip_relocation, ventura:        "9f8baf1e20b4e9f057fa0be7f49800a4c771844f2aa7d8711f0182326aa6d82a"
    sha256 cellar: :any_skip_relocation, monterey:       "9f8baf1e20b4e9f057fa0be7f49800a4c771844f2aa7d8711f0182326aa6d82a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7a4eaaeb3460c229c2df92f1f2fa89169cdd7d065657b56ddb0af5f4ced6303"
  end

  depends_on "pyqt"
  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "polib" do
    url "https://files.pythonhosted.org/packages/10/9a/79b1067d27e38ddf84fe7da6ec516f1743f31f752c6122193e7bce38bdbf/polib-1.2.0.tar.gz"
    sha256 "f3ef94aefed6e183e342a8a269ae1fc4742ba193186ad76f175938621dbfc26b"
  end

  resource "qtpy" do
    url "https://files.pythonhosted.org/packages/eb/9a/7ce646daefb2f85bf5b9c8ac461508b58fa5dcad6d40db476187fafd0148/QtPy-2.4.1.tar.gz"
    sha256 "a5a15ffd519550a1361bdc56ffc07fda56a6af7292f17c7b395d4083af632987"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
