class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/8c/7b/08046ef9330735f536a09a2e31b00f42bccdb2795dcd979636ba43bb2d63/mypy-1.14.0.tar.gz"
  sha256 "822dbd184d4a9804df5a7d5335a68cf7662930e70b8c1bc976645d1509f9a9d6"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4daf6c575d5229f983aa11ad964698b14c0235b87ba0549d1ab3ab09c97270e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06d1439d72977c5845c6b7d28c391a7275033644e654039bd4a6572cf3fa27aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1266aaf5cefa93d1d5aa34fc4f81e96243f80c87f4ede8aaef5f4dd141f3b6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "df56534191e938395fc79baad0c267f2d29ed96503554f6e7f34748f521e6195"
    sha256 cellar: :any_skip_relocation, ventura:       "f3876f395b305e51a7e05f7cbf4092ba7e6417052ba9eedd0ad5bdeeae88847c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "104b93195373d511eb95162dec6048c7b662855639f60dbe57eb1c71bfce090a"
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
