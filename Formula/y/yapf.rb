class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/b9/14/c1f0ebd083fddd38a7c832d5ffde343150bd465689d12c549c303fbcd0f5/yapf-0.40.2.tar.gz"
  sha256 "4dab8a5ed7134e26d57c1647c7483afb3f136878b579062b786c9ba16b94637b"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c6a0ade7d780a2cb5177cbd2a5889341d0818a25a1610414c9e3d874b05617d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4ae82c3715aec9adbbb2c923a83e97d67cd891de2cb576c53b6c2a416afff9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5088a7f86428d893db8e5c55bc8d7261a2ff90424abdf8b6ccedfb322bbdbb74"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bc4b9eb238bad289eb53b283a5cacf3ea63a38a6005200faf87da960ae6036c"
    sha256 cellar: :any_skip_relocation, ventura:        "d6e979502ef7269df066c1c794dbca76f4cd539f105429f7678a51a3e606613e"
    sha256 cellar: :any_skip_relocation, monterey:       "0e0d791e2074b168e53ae9819611c2464b4ca3f4f4f13a19bd2af72b5f5b7d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5804753090e2cbb020abf4bef0d3f05c4f2b17c0a46a770c50dba111c3f7dcfd"
  end

  depends_on "python@3.12"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/20/ff/bd28f70283b9cca0cbf0c2a6082acbecd822d1962ae7b2a904861b9965f8/importlib_metadata-8.0.0.tar.gz"
    sha256 "188bd24e4c346d3f0a933f275c2fec67050326a856b9a359881d7c2a697e8812"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/d3/20/b48f58857d98dcb78f9e30ed2cfe533025e2e9827bbd36ea0a64cc00cbc1/zipp-3.19.2.tar.gz"
    sha256 "bf1dcf6450f873a13e952a29504887c89e6de7506209e5b1bcc3460135d4de19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
