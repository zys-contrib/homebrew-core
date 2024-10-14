class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/f9/70/196a3339459fe22296ac9a883bbd998fcaf0db3e8d9a54cf4f53b722cad4/mypy-1.12.0.tar.gz"
  sha256 "65a22d87e757ccd95cbbf6f7e181e6caa87128255eb2b6be901bb71b26d8a99d"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "645c4a6112e3079b26cfab80e6e4e3832de0d854278ded6575dcec8d332afc6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8e0b55df3f60284bd876a653f538da3056f6e77a94b7b390b68044244b00328"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "734cbd4bf00d1d37117c0557a339e8482d649d8a83f7c43f16313bd185c14995"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5fa35cc24e7b692c9b3d988c2f2536f8cef8228ab1322ecc3b2a5553aa8527f"
    sha256 cellar: :any_skip_relocation, ventura:       "6f1cb6c751cbb305eba351d2ea6b91ee9ecf5a08fdb31af0503136d1078b66c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f8157025afad7644acfbf79e4fd8656b5220d09a2b8c34ac81bc48f35387270"
  end

  depends_on "python@3.12"

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
