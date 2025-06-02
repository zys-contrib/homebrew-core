class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/4c/fd/4e0ba675ef2f834e75874034178ecec0bed558e2b3151ccfa550c0d1bbcf/nvchecker-2.18.tar.gz"
  sha256 "d0a73275836e2bb836a58a6e1c8166e2268d4640898fedf0fe61e050b049ea1f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e13f098ebccea77167b2a632e8c036f982fd1c8e8dbb533a0cc4fb440ca38d1"
    sha256 cellar: :any,                 arm64_sonoma:  "a9286f997d28b46224b7499c172c84156e246d3edad09c1a7d4157f31616c963"
    sha256 cellar: :any,                 arm64_ventura: "27040eb40428ffef38b369735144c71645c596240951105a36bf5ee4e1833805"
    sha256 cellar: :any,                 sonoma:        "75adbd03c200dcb095761aa4a219ee5295d9e19e31ef6592d94d803b7e5be4ea"
    sha256 cellar: :any,                 ventura:       "a6328d80369d901b47b4d4d682669077b501892fc9fbf55fd1dbcec39b972b69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a14b19259887b5b449c2e220accde00bececa28b783201fe1d85538591d13ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "582511d1aae6e2fe9a54c09ce459414f2e2b9f96a732ecb4691d5acec2382a6c"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/71/35/fe5088d914905391ef2995102cf5e1892cf32cab1fa6ef8130631c89ec01/pycurl-7.45.6.tar.gz"
    sha256 "2b73e66b22719ea48ac08a93fc88e57ef36d46d03cb09d972063c9aa86bb74e6"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/ff/6a/b0b6d440e429d2267076c4819300d9929563b1da959cf1f68afbcd69fe45/structlog-25.3.0.tar.gz"
    sha256 "8dab497e6f6ca962abad0c283c46744185e0c9ba900db52a423cb6db99f7abeb"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/51/89/c72771c81d25d53fe33e3dca61c233b665b2780f21820ba6fd2c6793c12b/tornado-6.5.1.tar.gz"
    sha256 "84ceece391e8eb9b2b95578db65e920d2a61070260594819589609ba9bc6308c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~TOML
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    TOML

    output = JSON.parse(shell_output("#{bin}/nvchecker -c #{file} --logger=json"))
    assert_equal version.to_s, output["version"]
  end
end
