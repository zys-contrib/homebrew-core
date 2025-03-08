class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/d9/e3/69783bbb2a81098a7c6cad793b3cf8fced05d1d874b4492e3baf85bc270e/nvchecker-2.16.tar.gz"
  sha256 "c17ee55fbe14a8f8b38c339cda6dafad25279b86ef3a268695533d4fbde2ac86"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6734cb1c2faef177a4a410c3b061134f47d0964575d8c1a9a15d4dbf5cbb9622"
    sha256 cellar: :any,                 arm64_sonoma:  "6844adee3e3689ac09d7a0c6d1b390044fd61c1e6ef4c38f44e782050fef13f0"
    sha256 cellar: :any,                 arm64_ventura: "338d470c60339b4d4110a00787a5f9f9b923cae80bfedc8a18b05371e5e0c113"
    sha256 cellar: :any,                 sonoma:        "a1c6ebb73d117b38c53049a406838c5d1e3438af096e44b92e4894c1d91faf51"
    sha256 cellar: :any,                 ventura:       "0be60d1abbd3e2f59767fe7fa8f4757b0eb59c4c7a316e4d4902c617291c5977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcc81533608a5be3f12b965d04f00704e51a8863b69281db9412174acc935b08"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/71/35/fe5088d914905391ef2995102cf5e1892cf32cab1fa6ef8130631c89ec01/pycurl-7.45.6.tar.gz"
    sha256 "2b73e66b22719ea48ac08a93fc88e57ef36d46d03cb09d972063c9aa86bb74e6"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/25/fe/578db23e17392a8693b45a7b7dc6985370f51dd937157def8ecc7b20930d/structlog-25.1.0.tar.gz"
    sha256 "2ef2a572e0e27f09664965d31a576afe64e46ac6084ef5cec3c2b8cd6e4e3ad3"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/59/45/a0daf161f7d6f36c3ea5fc0c2de619746cc3dd4c76402e9db545bd920f63/tornado-6.4.2.tar.gz"
    sha256 "92bad5b4746e9879fd7bf1eb21dce4e3fc5128d71601f80005afa39237ad620b"
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
