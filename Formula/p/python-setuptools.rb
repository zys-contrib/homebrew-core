class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/26/da/7a7021c150030617f90aa4a90a5b23f7b49af877f70ca46967e991645117/setuptools-80.0.1.tar.gz"
  sha256 "20fe373a22ef9f3925512650d1db90b1b8de01cdb6df91ab1788263139cbf9a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e5cbb5b5a9d9b690ff3b4a31f4626df39c941cfe9688c49503574b176a9fce17"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    inreplace_paths = %w[
      _distutils/compilers/C/unix.py
      _vendor/platformdirs/unix.py
      tests/test_easy_install.py
    ]

    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."

      # Ensure uniform bottles
      setuptools_site_packages = prefix/Language::Python.site_packages(python)/"setuptools"
      inreplace setuptools_site_packages/"_vendor/platformdirs/macos.py", "/opt/homebrew", HOMEBREW_PREFIX

      inreplace_files = inreplace_paths.map { |file| setuptools_site_packages/file }
      inreplace_files += setuptools_site_packages.glob("_vendor/platformdirs-*dist-info/METADATA")
      inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import setuptools"
    end
  end
end
