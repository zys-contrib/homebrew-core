class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/62/eb/e9d1249ff56b11e63fd8c7d0fcc1f94704e21693c16862bf0ebfb07bd61a/dynaconf-3.2.11.tar.gz"
  sha256 "4cfc6a730c533bf1a1d0bf266ae202133a22236bb3227d23eff4b8542d4034a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d16d121cb8ee8c6f5db0f745e28413a935e997df9f8b5cbe9c317101cef64183"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_path_exists testpath/"settings.toml"
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
