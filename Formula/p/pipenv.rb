class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/34/34/d74db93377232bcd156132730a3e6d04ce7fbc07664e2bc558140337a378/pipenv-2025.0.1.tar.gz"
  sha256 "923bfdf4e41d160d23d91cc1a8a00ebdf25f8bad4f014c3a278512e4c4f2d1d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be0688b8e4bf1a6f5fbd6ddf484d5d8db177ea96b6ab548390751c12f9d09ea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be0688b8e4bf1a6f5fbd6ddf484d5d8db177ea96b6ab548390751c12f9d09ea9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be0688b8e4bf1a6f5fbd6ddf484d5d8db177ea96b6ab548390751c12f9d09ea9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ac881ddf91649888cc5b051a6b254695f6426042c50f94d386332c834663cdf"
    sha256 cellar: :any_skip_relocation, ventura:       "0ac881ddf91649888cc5b051a6b254695f6426042c50f94d386332c834663cdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4e58e171f7c33839b9e0bf8ad309ad326a1d8141cd93578c4801de5a53c122c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4e58e171f7c33839b9e0bf8ad309ad326a1d8141cd93578c4801de5a53c122c"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b6/2d/7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1/platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/bb/71/b6365e6325b3290e14957b2c3a804a529968c77a049b2ed40c095f749707/setuptools-79.0.1.tar.gz"
    sha256 "128ce7b8f33c3079fd1b067ecbb4051a66e8526e7b65f6cec075dfc650ddfa88"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/38/e0/633e369b91bbc664df47dcb5454b6c7cf441e8f5b9d0c250ce9f0546401e/virtualenv-20.30.0.tar.gz"
    sha256 "800863162bcaa5450a6e4d721049730e7f2dae07720e0902b0e4040bd6f9ada8"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/pipenv", shells:                 [:fish, :zsh],
                                                               shell_parameter_format: :click)
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output(bin/"pipenv")
    system bin/"pipenv", "--python", which(python3)
    system bin/"pipenv", "install", "requests"
    system bin/"pipenv", "install", "boto3"
    assert_path_exists testpath/"Pipfile"
    assert_path_exists testpath/"Pipfile.lock"
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
