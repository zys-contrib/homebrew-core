class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/8a/8b/ae50f468cdd5e1dc6e6969397bb76e75ca0fd39f7ab8e5a6e8b58ea7102f/setuptools-72.0.0.tar.gz"
  sha256 "5a0d9c6a2f332881a0153f629d8000118efd33255cfa802757924c53312c76da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ab8eb262297bfe67ef9ba4ec7d6de3ce941e00d55f09a0a2594299151fc6d30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ab8eb262297bfe67ef9ba4ec7d6de3ce941e00d55f09a0a2594299151fc6d30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ab8eb262297bfe67ef9ba4ec7d6de3ce941e00d55f09a0a2594299151fc6d30"
    sha256 cellar: :any_skip_relocation, sonoma:         "160f5ed98d10a734a476a640bac00c01624e7b3736c9fd28d3f4ec33dc364988"
    sha256 cellar: :any_skip_relocation, ventura:        "160f5ed98d10a734a476a640bac00c01624e7b3736c9fd28d3f4ec33dc364988"
    sha256 cellar: :any_skip_relocation, monterey:       "160f5ed98d10a734a476a640bac00c01624e7b3736c9fd28d3f4ec33dc364988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "426d87eeba12fcbbc9267807beb3aadf67d38b88fb2eeaa2432826976c7e654d"
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
