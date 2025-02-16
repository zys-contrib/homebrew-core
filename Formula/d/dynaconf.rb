class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/6d/8c/47a6542edb5072eebda480308db97a935f1fc5fbeb7659e499d2f53f5f42/dynaconf-3.2.9.tar.gz"
  sha256 "a612a05c0307b826193b9f7e738f9497c537d5b2668aa2979da3538d7dcdd400"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68b599b9950575e40cce970c3358a1b39204ec783bfda273e3a834a042d62271"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
