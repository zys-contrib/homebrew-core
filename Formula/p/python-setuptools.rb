class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/5e/11/487b18cc768e2ae25a919f230417983c8d5afa1b6ee0abd8b6db0b89fa1d/setuptools-72.1.0.tar.gz"
  sha256 "8d243eff56d095e5817f796ede6ae32941278f542e0f941867cc05ae52b162ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05bb34624edf2601d51ab54ebf0bca03203c16d293b010003b470c811e027c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05bb34624edf2601d51ab54ebf0bca03203c16d293b010003b470c811e027c6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05bb34624edf2601d51ab54ebf0bca03203c16d293b010003b470c811e027c6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b928da0e70d5c40af4b75d9efeb646dec9b7880af62acaf81ce2f0c00c7d9c53"
    sha256 cellar: :any_skip_relocation, ventura:        "b928da0e70d5c40af4b75d9efeb646dec9b7880af62acaf81ce2f0c00c7d9c53"
    sha256 cellar: :any_skip_relocation, monterey:       "b928da0e70d5c40af4b75d9efeb646dec9b7880af62acaf81ce2f0c00c7d9c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0139c810af38e882757150bb31ca921d42c420fdf099c1395a785a64baf27caf"
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
