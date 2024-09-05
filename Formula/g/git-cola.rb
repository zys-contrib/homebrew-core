class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/f0/9b/81c8279f27c52aabfcf92206c9b5124b36f55d14558d9126e97fb1c7a6da/git-cola-4.8.2.tar.gz"
  sha256 "4c5aa770035e7e6a321f4e3aa8a12b3ae75f6c4b4a5d978d86e70e30b3b6b84d"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d145f3bf1044b2cdcf36a0057e3ca2ac84be3b1a00d79f759881b3fb19728880"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d145f3bf1044b2cdcf36a0057e3ca2ac84be3b1a00d79f759881b3fb19728880"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d145f3bf1044b2cdcf36a0057e3ca2ac84be3b1a00d79f759881b3fb19728880"
    sha256 cellar: :any_skip_relocation, sonoma:         "a05bf7f6b4afbbea01e55c61fc8d3224dc80f26f20016ac7d4edbd557322c8af"
    sha256 cellar: :any_skip_relocation, ventura:        "a05bf7f6b4afbbea01e55c61fc8d3224dc80f26f20016ac7d4edbd557322c8af"
    sha256 cellar: :any_skip_relocation, monterey:       "a05bf7f6b4afbbea01e55c61fc8d3224dc80f26f20016ac7d4edbd557322c8af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ea410a32756f210979928aa57cb1797ebe391808bd0c942a77e1c1273a74ff0"
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
