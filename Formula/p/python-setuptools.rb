class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/d1/8e/1d0b941ce1151009c6d98a0a590a608f346d4d272ce95ca09ee2bbb592cd/setuptools-71.0.3.tar.gz"
  sha256 "3d8531791a27056f4a38cd3e54084d8b1c4228ff9cf3f2d7dd075ec99f9fd70d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a424c3ef3ef068420f461f3146c725980c0da7558ff6bba1d7bc85b9593eb24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a424c3ef3ef068420f461f3146c725980c0da7558ff6bba1d7bc85b9593eb24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a424c3ef3ef068420f461f3146c725980c0da7558ff6bba1d7bc85b9593eb24"
    sha256 cellar: :any_skip_relocation, sonoma:         "9599af9e777de315550a51c213311d582fcce238cb808adc96254cd5e1fc6486"
    sha256 cellar: :any_skip_relocation, ventura:        "9599af9e777de315550a51c213311d582fcce238cb808adc96254cd5e1fc6486"
    sha256 cellar: :any_skip_relocation, monterey:       "82fdf60a08557f2c21f324c6ad4cd6ef2a3810184e3fa0019eb7868b4348cffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42d236d302454514a99ba7bd2c868f83620fd17b0f89fba523aed21a3c20b475"
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
