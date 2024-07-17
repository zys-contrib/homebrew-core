class Tartufo < Formula
  include Language::Python::Virtualenv

  desc "Searches through git repositories for high entropy strings and secrets"
  homepage "https://tartufo.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/d5/ea/6248387282150270f1886d75111f776f43e694f488a3a1ea3b5b0d1195f1/tartufo-5.0.0.tar.gz"
  sha256 "99ab6652cae6de295aeb31089e9ba27d66d0ad695af493d2d5cbc795397d1c84"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/godaddy/tartufo.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "82cbe9b21439b6e66ea5226ecaf4248adf9fcc67fbccca2bc6f140f0425c40f8"
    sha256 cellar: :any,                 arm64_ventura:  "259625dd7034d7243204fea940b1599469a20cdd60290f0f5a1ee30169fabaa8"
    sha256 cellar: :any,                 arm64_monterey: "73d1b16bd1aef66347a682fa6298e81f297cda1264c2658589b5e20ee8ec3426"
    sha256 cellar: :any,                 sonoma:         "a642c1ddf6c9074bb206df05e8ae5e33e0de453e598f4549bcf89d95a02adb2e"
    sha256 cellar: :any,                 ventura:        "50f57bed0f4b3e940f36b76bd069d5f09b68dbee9e572405f18eb6041b1d77a1"
    sha256 cellar: :any,                 monterey:       "1a0c06e0f3bc4d9f200712c83f12aa6c7b9ef3c2013f7d311ad6905cd86d58de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f44c5168bfefe9795d915ea7b527d1b67f39500e1186cbb6a4bcaa0b329ee7a"
  end

  depends_on "libgit2@1.7"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/b6/a1/106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662/GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/f0/5e/6e05213a9163bad15489beda5f958500881d45889b0df01d7b8964f031bf/pygit2-1.14.1.tar.gz"
    sha256 "ec5958571b82a6351785ca645e5394c31ae45eec5384b2fa9c4e05dde3597ad6"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/10/37/dd53019ccb72ef7d73fff0bee9e20b16faff9658b47913a35d79e89978af/tomlkit-0.11.8.tar.gz"
    sha256 "9330fc7faa1db67b541b28e62018c17d20be733177d290a13b24c62d1614e0c3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tartufo --version")

    output = shell_output("#{bin}/tartufo scan-remote-repo https://github.com/godaddy/tartufo.git")
    assert_match "All clear. No secrets detected.", output
  end
end
