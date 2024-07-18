class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/0e/ae/4a643fdc3b2fe390a6accd55117d5c5af9fbe5da7d2d300c8dd52aa35555/setuptools-71.0.2.tar.gz"
  sha256 "ca359bea0cd5c8ce267d7463239107e87f312f2e2a11b6ca6357565d82b6c0d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a93b91a3ed8af87f3c947e31c7fbdf720fc2d02a241fff4796b4836f120c458e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a93b91a3ed8af87f3c947e31c7fbdf720fc2d02a241fff4796b4836f120c458e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a93b91a3ed8af87f3c947e31c7fbdf720fc2d02a241fff4796b4836f120c458e"
    sha256 cellar: :any_skip_relocation, sonoma:         "eed48d972fcfd8ff6c4dc2e4d7aad9bb770396a073f02d1c3649e52dec6cdf21"
    sha256 cellar: :any_skip_relocation, ventura:        "eed48d972fcfd8ff6c4dc2e4d7aad9bb770396a073f02d1c3649e52dec6cdf21"
    sha256 cellar: :any_skip_relocation, monterey:       "eed48d972fcfd8ff6c4dc2e4d7aad9bb770396a073f02d1c3649e52dec6cdf21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "751f772f2af6d6440139210afa933f3193e108ad61e5f6c8eacb05c4460a3a33"
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
