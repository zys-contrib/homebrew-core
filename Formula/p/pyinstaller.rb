class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/a8/b1/2949fe6d3874e961898ca5cfc1bf2cf13bdeea488b302e74a745bc28c8ba/pyinstaller-6.13.0.tar.gz"
  sha256 "38911feec2c5e215e5159a7e66fdb12400168bd116143b54a8a7a37f08733456"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "587564f2b16d8a3ddea2a2092dfce0b13a41cf58e754a4005d90e2879c161ee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08f530d0f592cb413f5aeaeb78b4c29c6ecf0fe948ef29bfb893753553789028"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d84b07ebb17fee1edef346faf70d4d70052ed1fdcb9153f2a970607e0b5591a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d9d52524af170915bee4968f4ca8430257894b377cb308dc66c6835771c713f"
    sha256 cellar: :any_skip_relocation, ventura:       "6ae43e011c0829ebb0ba4a972e44a680c10e6e058180abc4d68e2574053b6cbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a284364b0a6ac12e91293ce5b64a9bababcdbdf5044abb5dea1fbb5939e3f623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9acf51b2ade652c578e709190d7c983c639faba1f0c46a4e2cffd15c5bf2eda8"
  end

  depends_on "python@3.13"

  uses_from_macos "zlib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/e3/94/dfc5c7903306211798f990e6794c2eb7b8685ac487b26979e9255790419c/pyinstaller_hooks_contrib-2025.4.tar.gz"
    sha256 "5ce1afd1997b03e70f546207031cfdf2782030aabacc102190677059e2856446"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  def install
    cd "bootloader" do
      system "python3.13", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~PYTHON
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    PYTHON
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_path_exists testpath/"dist/easy_install"
  end
end
