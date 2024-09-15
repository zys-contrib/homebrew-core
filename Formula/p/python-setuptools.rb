class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/cd/01/e30d66bbb6403b7d41ac1ac0e3c51727c5e8f3558d8f9a9efe4282e90308/setuptools-74.1.3.tar.gz"
  sha256 "fbb126f14b0b9ffa54c4574a50ae60673bbe8ae0b1645889d10b3b14f5891d28"
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
