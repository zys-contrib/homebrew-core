class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/ae/f8/63ecf759c9149d7d7a8b612ebfe74901164dde9adcb1c40975ddc713db1c/reorder_python_imports-3.13.0.tar.gz"
  sha256 "994235fe9273373af6df7290de6a362a2426eb9bb800f5197367fe54b081f4d9"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "811806a260a4222b5c0e3a9d57742190ec27c6dc5d631bea6648f2c5c9b5b25e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "559576e8f8e7b85add2071857c12a70f1d749837dc732f5202dda11eaf891fba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca0b9735c93193e9d687782909b0912f8cca9008314c80abfc69ce1708c0866b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3f7e647bb739cdf2b44f000d4a0d73834234d9262e4239205c0db27bd3f1075"
    sha256 cellar: :any_skip_relocation, ventura:        "fea905f69f10190b0696e81f66f9f62e868b0cb07324a130924239b9d92a0d25"
    sha256 cellar: :any_skip_relocation, monterey:       "042dcbe53a84f21685ebca83179bfb64f804d1431194a62b157a0cda622bb5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfab9926d9f27a1ec50d80fe7b8da56e3737b90a6999ffe86b8dd4fc2b2d329d"
  end

  depends_on "python@3.12"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/7e/b6/6cdc486fced92110a8166aa190b7d60435165119990fc2e187a56d15144b/classify_imports-4.2.0.tar.gz"
    sha256 "7abfb7ea92149b29d046bd34573d247ba6e68cc28100c801eba4af17964fc40e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      from os import path
      import sys
    EOS
    system "#{bin}/reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}/test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end
