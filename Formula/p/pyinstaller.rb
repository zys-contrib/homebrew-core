class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/a2/c8/2802bbf8abe0312ba1250f0c20158db202135ed0475c88e19944ef11cdad/pyinstaller-6.8.0.tar.gz"
  sha256 "3f4b6520f4423fe19bcc2fd63ab7238851ae2bdcbc98f25bc5d2f97cc62012e9"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1c576e1415348867408f6d9d2b2beb1324023ed10ff16465afbf543b9c6ac4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2544f00ed3d1076c923f1132cf205e24d9c9657c787ae51b9519383ab193d5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "114c302eb15ef7aa5448a28ac90afaaeab31616757da82aca240e42b0414fb9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a17b75939a62ca0b790f01df91d93bdb7fe3146cbeafec9c8c9a46dd2df91ba1"
    sha256 cellar: :any_skip_relocation, ventura:        "44128c2d04ca865f48a6c0f0f50cc1b752a24efe515a68d8a5bc1f8e4f85d579"
    sha256 cellar: :any_skip_relocation, monterey:       "69d43b355b8ada4fcd5f5bb59d6a31e202fda675e09761b34bd0bbc06c2d2c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac3f7a74314a7e2b25ba978d6d4af9de48f5a02dc3610fc0d5d020aaf25b2c8"
  end

  depends_on "python@3.12"

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
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/b1/04/fd321018585c0751e8a4f857470e95d188aa80bc48002303cf26e5711d7d/pyinstaller_hooks_contrib-2024.7.tar.gz"
    sha256 "fd5f37dcf99bece184e40642af88be16a9b89613ecb958a8bd1136634fc9fac5"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  def install
    cd "bootloader" do
      system "python3.12", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~EOS
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    EOS
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
