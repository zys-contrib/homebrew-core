class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/24/65/19a02e93da9d9f118ecb311419a353ae68a8e236c057bf164c866daa227f/setuptools-80.2.0.tar.gz"
  sha256 "16a390b41627e1455567193435e7cafa9101803ffaa2fdd9ecd0af098301981d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "764d93a4bdf33796092a336b1f889c179235e4788386bbf067bf21724846331b"
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
