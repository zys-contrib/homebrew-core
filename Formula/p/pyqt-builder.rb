class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/04/78/ec38b8fa8f44d7437cc4b1930669d50baebb3c43c16d0a65c5b487fa2d12/pyqt_builder-1.17.0.tar.gz"
  sha256 "fce0e92346d2a4296525b7ad9f02b74ea425f26210390ae0d3e4ca08c31cf4cc"
  license "BSD-2-Clause"
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5043f2f1d35d5a4cb0225184869464fa99c9b4f59a5e9b0c40b9ecc56e7f38cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5043f2f1d35d5a4cb0225184869464fa99c9b4f59a5e9b0c40b9ecc56e7f38cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5043f2f1d35d5a4cb0225184869464fa99c9b4f59a5e9b0c40b9ecc56e7f38cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd0f23d71c7e6d76163f3fd067407c99abf4ecea11ffabcb13fb83cc0ee471a8"
    sha256 cellar: :any_skip_relocation, ventura:       "fd0f23d71c7e6d76163f3fd067407c99abf4ecea11ffabcb13fb83cc0ee471a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b7fc6031ad34bc6bdb55d1d20bea08cf89321779a7adb6e003cc0bb36dc2dd3"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/b8/dc/17b69b375103aa3db633b3f1f46bf7030cbe516b2b6d5dc73b7668a7840d/sip-6.9.0.tar.gz"
    sha256 "093fd0e15d99ae2f8a83dd7f7dbaa3ff250c582a77eb8e0845cd9acadb1f0934"
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
