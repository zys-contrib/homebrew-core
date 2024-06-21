class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/f0/73/9e2755469405520b38162a4f594db1e0a28e2d29ab367acba1cd3c0783b5/pyqt_builder-1.16.3.tar.gz"
  sha256 "3ce5c03dc3fc856b782da3f53b4f3f3b6556aad7bd8416d7bbfc274d03bcf032"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aafeb8bb22373ace45fc2d063ab271a70b90917a5dcb8fef2c741e72b7383697"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aafeb8bb22373ace45fc2d063ab271a70b90917a5dcb8fef2c741e72b7383697"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aafeb8bb22373ace45fc2d063ab271a70b90917a5dcb8fef2c741e72b7383697"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfc6aa9124c647c925b34481f4819a39847f991e4683577a0251837bff8cd802"
    sha256 cellar: :any_skip_relocation, ventura:        "dfc6aa9124c647c925b34481f4819a39847f991e4683577a0251837bff8cd802"
    sha256 cellar: :any_skip_relocation, monterey:       "dfc6aa9124c647c925b34481f4819a39847f991e4683577a0251837bff8cd802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a72dfffcf78fa58f6af5594100ef4a2435dcf0e524a461597ed14fb6eedcc7f"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/1c/1c/8a56622f2fc9ebb0df743373ef1a96c8e20410350d12f44ef03c588318c3/setuptools-70.1.0.tar.gz"
    sha256 "01a1e793faa5bd89abc851fa15d0a0db26f160890c7102cd8dce643e886b47f5"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/9f/aa/8c767fc6521fa69a0632d155dc6dad82ecbd522475d60caaefb444f98abc/sip-6.8.4.tar.gz"
    sha256 "c8f4032f656de3fedbf81243cdbc9e9fd4064945b8c6961eaa81f03cd88554cb"
  end

  def install
    python3 = "python3.12"
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
