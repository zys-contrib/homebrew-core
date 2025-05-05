class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/53/07/655f4fb9592967f49197b00015bb5538d3ed1f8f96621a10bebc3bb822e2/virtualenv-20.31.1.tar.gz"
  sha256 "65442939608aeebb9284cd30baca5865fcd9f12b58bb740a24b220030df46d26"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "005f759bd5350fe981c85b20035b3d7f6b658eb621f9af16dfdafd173cfd07b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "005f759bd5350fe981c85b20035b3d7f6b658eb621f9af16dfdafd173cfd07b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "005f759bd5350fe981c85b20035b3d7f6b658eb621f9af16dfdafd173cfd07b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b64286f1bbe45d28ee9cb68dacb2936575d90909384524814fd664cf4f0c1e05"
    sha256 cellar: :any_skip_relocation, ventura:       "b64286f1bbe45d28ee9cb68dacb2936575d90909384524814fd664cf4f0c1e05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ae48a6a7e48f561542bf90c1542f6e895ea43e72877bebf5eb6f31889ff829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ae48a6a7e48f561542bf90c1542f6e895ea43e72877bebf5eb6f31889ff829"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b6/2d/7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1/platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
