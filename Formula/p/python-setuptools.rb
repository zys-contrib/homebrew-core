class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/0d/9d/c587bea18a7e40099857015baee4cece7aca32cd404af953bdeb95ac8e47/setuptools-70.1.1.tar.gz"
  sha256 "937a48c7cdb7a21eb53cd7f9b59e525503aa8abaf3584c730dc5f7a5bec3a650"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97419f6abe0c715c2b67a70b1a04f4b3d4e1f6a34bfd9cdc32cd658d1b3761ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97419f6abe0c715c2b67a70b1a04f4b3d4e1f6a34bfd9cdc32cd658d1b3761ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97419f6abe0c715c2b67a70b1a04f4b3d4e1f6a34bfd9cdc32cd658d1b3761ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "4118587ee4bce76256e25607eb9af5a56c14c4615b2ce35ae7b910e7a489ec7b"
    sha256 cellar: :any_skip_relocation, ventura:        "4118587ee4bce76256e25607eb9af5a56c14c4615b2ce35ae7b910e7a489ec7b"
    sha256 cellar: :any_skip_relocation, monterey:       "4118587ee4bce76256e25607eb9af5a56c14c4615b2ce35ae7b910e7a489ec7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97419f6abe0c715c2b67a70b1a04f4b3d4e1f6a34bfd9cdc32cd658d1b3761ca"
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
