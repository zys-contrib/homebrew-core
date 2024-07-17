class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/32/37/8751819aebb61ff15cc438e9d80d7b32d6cef4f266a1145a7037cbbfd693/setuptools-71.0.0.tar.gz"
  sha256 "98da3b8aca443b9848a209ae4165e2edede62633219afa493a58fbba57f72e2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4891411677a80b8fa10903357526de1b19b7b70d373dfd16b95162b09e3ae878"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4891411677a80b8fa10903357526de1b19b7b70d373dfd16b95162b09e3ae878"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4891411677a80b8fa10903357526de1b19b7b70d373dfd16b95162b09e3ae878"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d26ae734c39e859e1366b14bb15391740f7db02fa1d383a7f67d03b1159653f"
    sha256 cellar: :any_skip_relocation, ventura:        "3d26ae734c39e859e1366b14bb15391740f7db02fa1d383a7f67d03b1159653f"
    sha256 cellar: :any_skip_relocation, monterey:       "582d5089333a9dc3a33b159d6cc261e8f620cd60f657dce5e34d12365eb0535f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4891411677a80b8fa10903357526de1b19b7b70d373dfd16b95162b09e3ae878"
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
