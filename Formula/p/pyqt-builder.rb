class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/18/cf/9927e22ece4b20e24fb236dba358dd14f55b9e07fcde3a5ad6711da9792e/pyqt_builder-1.18.2.tar.gz"
  sha256 "56dfea461484a87a8f0c8b0229190defc436d7ec5de71102e20b35e5639180bc"
  license "BSD-2-Clause"
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f9c9a7e2ca2bbe7f09634407a93aea1de9ecd5e898656c6157070cebd210d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f9c9a7e2ca2bbe7f09634407a93aea1de9ecd5e898656c6157070cebd210d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6f9c9a7e2ca2bbe7f09634407a93aea1de9ecd5e898656c6157070cebd210d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbcd019ff2169a36e038d2991a7c237dbe504c7b68a0ac943e32d2053765754c"
    sha256 cellar: :any_skip_relocation, ventura:       "bbcd019ff2169a36e038d2991a7c237dbe504c7b68a0ac943e32d2053765754c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d76dd4cd42912d127622a98c68edb106af7c530482d1361565a7eebc9307772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d76dd4cd42912d127622a98c68edb106af7c530482d1361565a7eebc9307772"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/25/fb/67c5ebb38defec74da7a3e2e0fa994809d152e3d4097f260bc7862a7af30/sip-6.12.0.tar.gz"
    sha256 "083ced94f85315493231119a63970b2ba42b1d38b38e730a70e02a99191a89c6"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{which(python3)}\""
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system libexec/"bin/python", "-c", "import pyqtbuild"
  end
end
