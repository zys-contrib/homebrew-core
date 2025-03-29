class Pycodestyle < Formula
  include Language::Python::Shebang

  desc "Simple Python style checker in one Python file"
  homepage "https://pycodestyle.pycqa.org/"
  url "https://github.com/PyCQA/pycodestyle/archive/refs/tags/2.13.0.tar.gz"
  sha256 "b1a4db0d9b8285f6643bcdb41362be6d6c94b891b13ead09c57a2513c46b717b"
  license "MIT"
  head "https://github.com/PyCQA/pycodestyle.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "711ddb1897f67e34b9e67d3e1710b229f19fe40e78993119e9ccb0006a7e8c1d"
  end

  depends_on "python@3.13"

  def install
    rewrite_shebang detected_python_shebang, "pycodestyle.py"
    bin.install "pycodestyle.py" => "pycodestyle"
  end

  test do
    # test invocation on a file with no issues
    (testpath/"ok.py").write <<~PYTHON
      print(1)
    PYTHON
    assert_empty shell_output("#{bin}/pycodestyle ok.py")

    # test invocation on a file with a whitespace style issue
    (testpath/"ws.py").write <<~PYTHON
      print( 1)
    PYTHON
    assert_equal "ws.py:1:7: E201 whitespace after '('\n",
      shell_output("#{bin}/pycodestyle ws.py", 1)

    # test invocation on a file with an import not at top of file
    (testpath/"imp.py").write <<~PYTHON
      pass
      import sys
    PYTHON
    assert_equal "imp.py:2:1: E402 module level import not at top of file\n",
      shell_output("#{bin}/pycodestyle imp.py", 1)
  end
end
