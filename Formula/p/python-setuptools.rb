class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/ac/11/0a953274017ca5c33a9831bc5e052e825d174a3551bd18924777794c8162/setuptools-74.1.0.tar.gz"
  sha256 "bea195a800f510ba3a2bc65645c88b7e016fe36709fefc58a880c4ae8a0138d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94e6b0211b4e6befec438fca9eb4675db3f0c185d8e2791f4baeb85dd8f10f9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94e6b0211b4e6befec438fca9eb4675db3f0c185d8e2791f4baeb85dd8f10f9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94e6b0211b4e6befec438fca9eb4675db3f0c185d8e2791f4baeb85dd8f10f9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "20272593eeea9537a7e66609fbaf3a60f830ae5c6953944203ce0792f4672538"
    sha256 cellar: :any_skip_relocation, ventura:        "20272593eeea9537a7e66609fbaf3a60f830ae5c6953944203ce0792f4672538"
    sha256 cellar: :any_skip_relocation, monterey:       "20272593eeea9537a7e66609fbaf3a60f830ae5c6953944203ce0792f4672538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22ac439574d804495661b50c6099a5cdd4d7db78596fbe683f1eb13c133b634b"
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
