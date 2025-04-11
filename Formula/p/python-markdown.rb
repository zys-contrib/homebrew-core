class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/2f/15/222b423b0b88689c266d9eac4e61396fe2cc53464459d6a37618ac863b24/markdown-3.8.tar.gz"
  sha256 "7df81e63f0df5c4b24b7d156eb81e4690595239b7d70937d0409f1b0de319c6f"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "d34f9b98ef785f768aa73285a5fe76e127c5a86ab5dfef5ce6bc85b77ccf9009"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
