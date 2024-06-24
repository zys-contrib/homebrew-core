class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/22/02/4785861427848cc11e452cc62bb541006a1087cf04a1de83aedd5530b948/Markdown-3.6.tar.gz"
  sha256 "ed4f41f6daecbeeb96e576ce414c41d2d876daa9a16cb35fa8ed8c2ddfad0224"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81a78ea79b6c4c44b860a38c8e08a0edb5a2a13ce2f0f2b5d0f4f95d8451cf95"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
