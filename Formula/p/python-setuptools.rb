class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/fa/2b/287ade3a580869e6178cb37d045f54272b1f006f2c0ff6fad08db258d027/setuptools-76.1.0.tar.gz"
  sha256 "4959b9ad482ada2ba2320c8f1a8d8481d4d8d668908a7a1b84d987375cd7f5bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "602a29810aaaf5ee6c0487878f4fe579e49349efd44542706becbc8034720be8"
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
