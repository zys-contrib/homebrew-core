class EulerPy < Formula
  include Language::Python::Virtualenv

  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://files.pythonhosted.org/packages/a6/41/f074081bc036fbe2f066746e44020947ecf06ac53b6319a826023b8b5333/EulerPy-1.4.0.tar.gz"
  sha256 "83b2175ee1d875e0f52b0d7bae1fb8500f5098ac6de5364a94bc540fb9408d23"
  license "MIT"
  revision 3
  head "https://github.com/iKevinY/EulerPy.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adf91adfb085418d610cfa665aa90519f4c86f5dcf747688fd7bf914288e4c9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5388db31e25c21e3f546cdac838fcd36dbe658108d1e4e935dc4fb357db5cc00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8f9ed0803d146828690d8a1ec64e89284f53502a7039609ef4aff7ef58ea460"
    sha256 cellar: :any_skip_relocation, sonoma:         "78f7050a20167ca41518e78ef644935640d9f0843005a57ae967a340dd0acb61"
    sha256 cellar: :any_skip_relocation, ventura:        "fe998cb35bc72589040156208cb34a87c3da92a4a511a4715e80c2d18f0a6466"
    sha256 cellar: :any_skip_relocation, monterey:       "866be747b52ec9dd4639fbf8f876691d2e9ebd47fe837146869dc127d8b7cdbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a279b7c32fe9e5ebf6a59066d85b36379d5c28434411c62a66f5532ae65beae8"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "open3"
    output = Open3.capture2("#{bin}/euler", stdin_data: "\n")
    # output[0] is the stdout text, output[1] is the exit code
    assert_match 'Successfully created "001.py".', output[0]
    assert_equal 0, output[1]
    assert_predicate testpath/"001.py", :exist?
  end
end
