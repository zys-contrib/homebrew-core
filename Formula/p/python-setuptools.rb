class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/ce/ef/013ded5b0d259f3fa636bf35de186f0061c09fbe124020ce6b8db68c83af/setuptools-72.2.0.tar.gz"
  sha256 "80aacbf633704e9c8bfa1d99fa5dd4dc59573efcf9e4042c13d3bcef91ac2ef9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74229994656f72b76e44ee168eab233b9bb1d07a479095998493eb7def952210"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74229994656f72b76e44ee168eab233b9bb1d07a479095998493eb7def952210"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74229994656f72b76e44ee168eab233b9bb1d07a479095998493eb7def952210"
    sha256 cellar: :any_skip_relocation, sonoma:         "735a65ff7704697e732eeb68cfbbaa9309024bc8f904d1ec13f8045e9b30ec17"
    sha256 cellar: :any_skip_relocation, ventura:        "735a65ff7704697e732eeb68cfbbaa9309024bc8f904d1ec13f8045e9b30ec17"
    sha256 cellar: :any_skip_relocation, monterey:       "735a65ff7704697e732eeb68cfbbaa9309024bc8f904d1ec13f8045e9b30ec17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8455722c96a7578f8f7b2b9ffe4d0674b35d9d275bcde824a578e7c1223465af"
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
