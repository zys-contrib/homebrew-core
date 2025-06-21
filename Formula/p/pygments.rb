class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
  sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98328d1e104147cef03596a6f3be5ef664810d9cae9cf17d6d8eaf2803285775"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
      print(os.getcwd())
    PYTHON

    system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
    assert_path_exists testpath/"test.html"
  end
end
