class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/54/28/3af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472/markdown-3.7.tar.gz"
  sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d768ef8b25a991d85f25f9b54ccda3b0156a5f2a1ccd1b41a878f9dfb9143c89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d768ef8b25a991d85f25f9b54ccda3b0156a5f2a1ccd1b41a878f9dfb9143c89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d768ef8b25a991d85f25f9b54ccda3b0156a5f2a1ccd1b41a878f9dfb9143c89"
    sha256 cellar: :any_skip_relocation, sonoma:         "d768ef8b25a991d85f25f9b54ccda3b0156a5f2a1ccd1b41a878f9dfb9143c89"
    sha256 cellar: :any_skip_relocation, ventura:        "d768ef8b25a991d85f25f9b54ccda3b0156a5f2a1ccd1b41a878f9dfb9143c89"
    sha256 cellar: :any_skip_relocation, monterey:       "d768ef8b25a991d85f25f9b54ccda3b0156a5f2a1ccd1b41a878f9dfb9143c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3a6fb9c640fd8b1bd6ec3fefd3f1741db6be5e754c35bd0e230c1c996a72e1"
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
