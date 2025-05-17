class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/09/a9/d1ae2b45e798593b31fcc2a9f9aa91df169c8592f03fdddbc0a2a1037f21/nvchecker-2.17.tar.gz"
  sha256 "06995aec5a5e81e8ac19796741095609916b6f5bea46dd803e0b0aedb4fa2fb6"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c75e3685064ce5156714f628fd0a778ac51d9f5a3df9971073eaccf9df910475"
    sha256 cellar: :any,                 arm64_sonoma:  "0bdcef43afc810b011ba8d26bc73c6c2f5f335fd991d390313fe5161a88430c2"
    sha256 cellar: :any,                 arm64_ventura: "b1e3b628d384309fce5cd6c696855ecbb4e98c6cc394f8464afafaa58fc408a9"
    sha256 cellar: :any,                 sonoma:        "f3c1c657166a0e5b205bd0f77afb03742a9547f444950eb8953c79ebcbc92aa0"
    sha256 cellar: :any,                 ventura:       "ca5c0620d36e8944cc21d3ec4ebd39a038f1d40e883b59a945b6b596a41796ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5ae6c723086420d4ec8fe1908f38564a1201a7d2a91490981de2de313692773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "626bf81b2fd4f36f58e9ea5d5cc2058c9bc778d2f877de91913048c4a2493bad"
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
    url "https://files.pythonhosted.org/packages/63/c4/bb3bd68b1b3cd30abc6411469875e6d32004397ccc4a3230479f86f86a73/tornado-6.5.tar.gz"
    sha256 "c70c0a26d5b2d85440e4debd14a8d0b463a0cf35d92d3af05f5f1ffa8675c826"
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
