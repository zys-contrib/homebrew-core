class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/68/60/db9f95e6ad456f1872486769c55628c7901fb4de5a72c2f7bdd912abf0c1/virtualenv-20.26.3.tar.gz"
  sha256 "4c43a2a236279d9ea36a0d76f98d84bd6ca94ac4e0f4a3b9d46d05e10fea542a"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fafad463983dcef9ceeb7180a0d8082f0a21a7e03849d74e13d248d65a2cde1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d41c26d0565120d650ceb6baae0d0a39a909f4183280d6e9b3f577f3f7884b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73c4c3caf40272c284350f41c196d02a3d605399aafd3af0b125ce18892b0de0"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc5a90176dadd6ee9d0fbee6fc8e6677fce9525ac238c58c315953a7c597e0c0"
    sha256 cellar: :any_skip_relocation, ventura:        "b235e85b6e2497ee70bdfb7cdd4d94372c437f1353302caada36bad5ab772e6b"
    sha256 cellar: :any_skip_relocation, monterey:       "62be0063ef44583912ba68677d18abe13c6bd3f1b86506473b2b0c1e8d1a876c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fe5e91d24a61daa71be01a77122722266f4597f78f92264836c789f8ce61524"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/7d/98/6e68cf474669042ba6ba0a7761b8be04beb8131b366d5c6b1596f8cdfec2/filelock-3.15.3.tar.gz"
    sha256 "e1199bf5194a2277273dacd50269f0d87d0682088a3c561c15674ea9005d8635"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
