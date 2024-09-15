class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/a7/17/133e1cd1e24373e1898ca3c7330f5c385b46c7091f0451e678f37245591b/setuptools-75.0.0.tar.gz"
  sha256 "25af69c809d9334cd8e653d385277abeb5a102dca255954005a7092d282575ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30ca813a08196c60f57289045b7708b04f8d786d99f8f8c1125d8145d7b23729"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30ca813a08196c60f57289045b7708b04f8d786d99f8f8c1125d8145d7b23729"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30ca813a08196c60f57289045b7708b04f8d786d99f8f8c1125d8145d7b23729"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b85089398190084856bb38b8988f6db7b9b483b34c1ec9f3e6d98a6e921ba30"
    sha256 cellar: :any_skip_relocation, ventura:       "0b85089398190084856bb38b8988f6db7b9b483b34c1ec9f3e6d98a6e921ba30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6b72e5abf1ad4260470950c82e6df8b6067e2ba473328a09cfab15bad0bc9af"
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
