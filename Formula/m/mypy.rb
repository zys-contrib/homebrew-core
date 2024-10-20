class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/17/03/744330105a74dc004578f47ec27e1bf66b1dd5664ea444d18423e41343bd/mypy-1.12.1.tar.gz"
  sha256 "f5b3936f7a6d0e8280c9bdef94c7ce4847f5cdfc258fbb2c29a8c1711e8bb96d"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96054e0223d3a4fac0de88d8de6975c16079ab9db7189e70828db72cf32ada8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae81c57e163517e1fe9106f8cd1d904b527d1ace75ddbb128adbf2f0662eceef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "823368210026cacd450fb771016fd43df55c70d1b025650603f26f8835da7759"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fcb712bd96d29a48a65812d2eb152748f8ab2b487b99aea520faf502a61ad38"
    sha256 cellar: :any_skip_relocation, ventura:       "609f4d89d4dd2aaae363b2600a8d01cd6dcb9821f5c4dafcb68949d6a2d3f26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32019750df6b4a336c0ab29744f7267ce470fb6b4bcf30adcf00b6e7965687ef"
  end

  depends_on "python@3.13"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
