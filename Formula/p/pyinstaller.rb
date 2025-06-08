class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/9f/4a/d66d3a9c34349d73eb099401060e2591da8ccc5ed427e54fff3961302513/pyinstaller-6.14.1.tar.gz"
  sha256 "35d5c06a668e21f0122178dbf20e40fd21012dc8f6170042af6050c4e7b3edca"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40ddcdd453940a6f1077e5ec2dc19347fefcad6968e5e3539ea92ace800636ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a15f1ac2162bab20c33a65d1c027a6605b9befc1ca2d453be760fa4a7cdc6c89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21bcdb8255e236dc7873e9fda9504f2df86c5e6383a5e93e74c5db4ca3ec3671"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c3060dd927479cfe1ef8a220e48fa185bb5f053b64c3258bac6d2c260a3ec43"
    sha256 cellar: :any_skip_relocation, ventura:       "a1720f76fc3aa2c31dd5d017d70fe1bd192d5ad9669c1792a5a6e75eacbe0abf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "213b08559967bae95ad7b92e9bfcdade5aef39805489b320cacf141c6dcea688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef323eb36cf68a82a9d1e2ab496bada2dc500bdd47779edd144abe5afa6d466a"
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
    url "https://files.pythonhosted.org/packages/5f/ff/e3376595935d5f8135964d2177cd3e3e0c1b5a6237497d9775237c247a5d/pyinstaller_hooks_contrib-2025.5.tar.gz"
    sha256 "707386770b8fe066c04aad18a71bc483c7b25e18b4750a756999f7da2ab31982"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
