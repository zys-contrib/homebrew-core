class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
  sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3301145d7b80c94c0e35b8328e7a3d84cedc6e1b3e9aff136865093de644ce04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3301145d7b80c94c0e35b8328e7a3d84cedc6e1b3e9aff136865093de644ce04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3301145d7b80c94c0e35b8328e7a3d84cedc6e1b3e9aff136865093de644ce04"
    sha256 cellar: :any_skip_relocation, sonoma:        "41349f8c73c63e9169c59d67fcd379c60c2389034f22f8f46576c5ca681eeee6"
    sha256 cellar: :any_skip_relocation, ventura:       "41349f8c73c63e9169c59d67fcd379c60c2389034f22f8f46576c5ca681eeee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "397fb43bfe89fc25a7ceb0d9f110af50a55bf01e00e3a239b0b5839bb5a0da7d"
  end

  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import setuptools"
    end
  end
end
