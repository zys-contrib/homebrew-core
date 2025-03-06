class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/c7/9c/57d19fa093bcf5ac61a48087dd44d00655f85421d1aa9722f8befbf3f40a/virtualenv-20.29.3.tar.gz"
  sha256 "95e39403fcf3940ac45bc717597dba16110b74506131845d9b687d5e73d947ac"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cc974e506610e8f9be4f08735ca5e2a93968b9552b500ed9e1fc26cad4468b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cc974e506610e8f9be4f08735ca5e2a93968b9552b500ed9e1fc26cad4468b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cc974e506610e8f9be4f08735ca5e2a93968b9552b500ed9e1fc26cad4468b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9df836255af453b6249cc72e8fd7e326be7114043b7280f30cf91ac38f20706"
    sha256 cellar: :any_skip_relocation, ventura:       "c9df836255af453b6249cc72e8fd7e326be7114043b7280f30cf91ac38f20706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2558af06383e70c528eba40ea120ed3149f313e969f7603682ae26859bc6ad5d"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/dc/9c/0b15fb47b464e1b663b1acd1253a062aa5feecb07d4e597daea542ebd2b5/filelock-3.17.0.tar.gz"
    sha256 "ee4e77401ef576ebb38cd7f13b9b28893194acc20a8e68e18730ba9c0e54660e"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
