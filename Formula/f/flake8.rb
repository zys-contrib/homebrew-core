class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/e7/c4/5842fc9fc94584c455543540af62fd9900faade32511fab650e9891ec225/flake8-7.2.0.tar.gz"
  sha256 "fa558ae3f6f7dbf2b4f22663e5343b6b6023620461f8d4ff2019ef4b5ee70426"
  license "MIT"
  head "https://github.com/PyCQA/flake8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc6472bbbe85644ceb3ca79ebdad429eba7aad1f29da85c5a5a7324fe952b8c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc6472bbbe85644ceb3ca79ebdad429eba7aad1f29da85c5a5a7324fe952b8c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc6472bbbe85644ceb3ca79ebdad429eba7aad1f29da85c5a5a7324fe952b8c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8292895a9196bed1a95f2e23df67d054d91ab214a0ab28fc7f7ba10493e6082b"
    sha256 cellar: :any_skip_relocation, ventura:       "8292895a9196bed1a95f2e23df67d054d91ab214a0ab28fc7f7ba10493e6082b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e53312ee99ba86180c06a373785e256fd8145bbb304cf0a76d113fb5fcd3c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc6472bbbe85644ceb3ca79ebdad429eba7aad1f29da85c5a5a7324fe952b8c9"
  end

  depends_on "python@3.13"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/04/6e/1f4a62078e4d95d82367f24e685aef3a672abfd27d1a868068fed4ed2254/pycodestyle-2.13.0.tar.gz"
    sha256 "c8415bf09abe81d9c7f872502a6eee881fbe85d8763dd5b9924bb0a01d67efae"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/cf/8b/aee1357b4c52be2b955e86bc2e5bba5492d6bf6d94138f056e63c349d2d9/pyflakes-3.3.0.tar.gz"
    sha256 "1955be314ebe8e9bdd100d5877fe10f0fd47fb2497e4f365e981a1a87cc8d9d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-bad.py").write <<~PYTHON
      print ("Hello World!")
    PYTHON

    (testpath/"test-good.py").write <<~PYTHON
      print("Hello World!")
    PYTHON

    assert_match "E211", shell_output("#{bin}/flake8 test-bad.py", 1)
    assert_empty shell_output("#{bin}/flake8 test-good.py")
  end
end
