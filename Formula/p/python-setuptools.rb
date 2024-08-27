class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/6a/21/8fd457d5a979109603e0e460c73177c3a9b6b7abcd136d0146156da95895/setuptools-74.0.0.tar.gz"
  sha256 "a85e96b8be2b906f3e3e789adec6a9323abf79758ecfa3065bd740d81158b11e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d67fb05597ca4e5250c551333b0a3a4604dd29c62af3b2e48fc762deabb79bdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d67fb05597ca4e5250c551333b0a3a4604dd29c62af3b2e48fc762deabb79bdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d67fb05597ca4e5250c551333b0a3a4604dd29c62af3b2e48fc762deabb79bdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "658bee7b856a56286109dd83a475a13ffc1a0e7182fe59bd009547d4c261146d"
    sha256 cellar: :any_skip_relocation, ventura:        "658bee7b856a56286109dd83a475a13ffc1a0e7182fe59bd009547d4c261146d"
    sha256 cellar: :any_skip_relocation, monterey:       "658bee7b856a56286109dd83a475a13ffc1a0e7182fe59bd009547d4c261146d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e39cf7e8f3fa3d30cb456c3c1c432f2a5b18fb97e81ea6c68c4cf96bdc068ce7"
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
