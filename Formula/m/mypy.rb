class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/d4/38/13c2f1abae94d5ea0354e146b95a1be9b2137a0d506728e0da037c4276f6/mypy-1.16.0.tar.gz"
  sha256 "84b94283f817e2aa6350a14b4a8fb2a35a53c286f97c9d30f53b63620e7af8ab"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47a46cf281316caa47a3c03130a1dbb302bf9c4b744300d848ebb98e31b936f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ed30d04ea17719cff0a7a43dc8f2c038c3e776c1cadf97936203787bb63360d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60f43861fad3cb704383a97d5ce98829b77a076afe2ba8c0129f7179f3590c6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e578864a81144771caffa814b3334c2fcedd2863a57ae170f02bc432743e6ce"
    sha256 cellar: :any_skip_relocation, ventura:       "492cdd65beec15229107beca1198e90a9c560138f8c749ddefc5539f392c5ed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8765920d1c8270415ec11c3e121512cd97b497f1ba4277bae9a4fd053f91b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eceba777bfcaf012dcf14739c7899fbfcf08c9b01369a019f0e3d662760db1c0"
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
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
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
