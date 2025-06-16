class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/81/69/92c7fa98112e4d9eb075a239caa4ef4649ad7d441545ccffbd5e34607cbb/mypy-1.16.1.tar.gz"
  sha256 "6bd00a0a2094841c5e47e7374bb42b83d64c527a502e3334e1173a0c24437bab"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d830a7088dde741dd5c44208f2e9cf301007c6b1f90fd37c36205c11bc3070c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36a2cc890d5f3b944179b0b477d58131903885dbe0be57d9e6fbfe7324782307"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5df643805c93a15c8fd9521a779e0bb782c5db86d4fd20fb8a82cbd2a08dc83"
    sha256 cellar: :any_skip_relocation, sonoma:        "43cbd6132240d845442d7008614e4b1edae52682cf55df5f1ed687b6b02bbfb5"
    sha256 cellar: :any_skip_relocation, ventura:       "0f06af1686924f7f094454f12c72a4716e89cd1414d4e6ed0570b43366ad7a83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abf641ca5f2da8d141804775179162795a46b7ef2b9f18e13cd0ef669012ff27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a24800f287ba98c8c09d00fcecdaf983d5b77d57134f801b84db46075f599e"
  end

  depends_on "python@3.13"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d1/bc/51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5/typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def p() -> None:
        print('hello')
      a = p()
    PYTHON
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
