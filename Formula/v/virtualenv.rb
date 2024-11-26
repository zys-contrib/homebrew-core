class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/bf/75/53316a5a8050069228a2f6d11f32046cfa94fbb6cc3f08703f59b873de2e/virtualenv-20.28.0.tar.gz"
  sha256 "2c9c3262bb8e7b87ea801d715fae4495e6032450c71d2309be9550e7364049aa"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11fce5f2b079b35fc1e4648678c4767c7b50debdef4412a52c8a0afc35445754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11fce5f2b079b35fc1e4648678c4767c7b50debdef4412a52c8a0afc35445754"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11fce5f2b079b35fc1e4648678c4767c7b50debdef4412a52c8a0afc35445754"
    sha256 cellar: :any_skip_relocation, sonoma:        "898494253c6d2066bac72c5cbe923c4d277c3ea808f21a52972994351a4ff8a2"
    sha256 cellar: :any_skip_relocation, ventura:       "898494253c6d2066bac72c5cbe923c4d277c3ea808f21a52972994351a4ff8a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "474032101317938d6cd1eb869e1adf8523bd1a79ecde2e8bf7e237df4972fa80"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
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
