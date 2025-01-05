class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/d3/c0/9c9832e5be227c40e1ce774d493065f83a91d6430baa7e372094e9683a45/pygments-2.19.0.tar.gz"
  sha256 "afc4146269910d4bdfabcd27c24923137a74d562a23a320a41a55ad303e19783"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "5037962de309d66c8e911926c625c979fb4d414c756aef3c74542d8e50c02355"
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
    assert_predicate testpath/"test.html", :exist?
  end
end
