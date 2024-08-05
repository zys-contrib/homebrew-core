class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/84/4d/b720d6000f4ca77f030bd70f12550820f0766b568e43f11af7f7ad9061aa/cython-3.0.11.tar.gz"
  sha256 "7146dd2af8682b4ca61331851e6aebce9fe5158e75300343f80c07ca80b1faff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca2588052ba86d0e310f26b8acd8116e7346306483446b7b61e83014fae0bcf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57fbc8fef50d02de7e8807119aebd4ba3d645f1527f24c5ad755132fc0267c97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f5a6277b1e740eb1efc9e48d19abb23bf79695abe58288e82436b825d63c013"
    sha256 cellar: :any_skip_relocation, sonoma:         "313a30f3440adc4f013a8d313a6e1c237457cd3ac05a4a75070b32f7a9ea0907"
    sha256 cellar: :any_skip_relocation, ventura:        "24dde71147d7b8e7e61559a67e7b177580770b812974e33e9f5148879c5b5614"
    sha256 cellar: :any_skip_relocation, monterey:       "3745bbc021c2c2292c37e5bd0bdb4a4ee473751cea89e60c0420f21a0563cbf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f54316fa17664dce2527fe4ba8f6f8427e9288fece9c8c0d9ae7e43e5884f4b5"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system python3, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python3} -c 'import package_manager'")
  end
end
