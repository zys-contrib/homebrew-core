class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/50/d8/30873d2b7b57dee9263e53d142da044c4600a46f2d28374b3e38b023df16/autopep8-2.3.2.tar.gz"
  sha256 "89440a4f969197b69a995e4ce0661b031f455a9f776d2c5ba3dbd83466931758"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "e9743fa4892acbd3dd30a24f82e52df2db9cc7bd20e5d3e0c43f2c37de60e02f"
  end

  depends_on "python@3.13"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/43/aa/210b2c9aedd8c1cbeea31a50e42050ad56187754b34eb214c46709445801/pycodestyle-2.12.1.tar.gz"
    sha256 "6838eae08bbce4f6accd5d5572075c63626a15ee3e6f842df996bf62f6d73521"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'", 0)
    assert_equal "x = 'homebrew'", output.strip
  end
end
