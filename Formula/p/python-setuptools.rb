class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/32/37/8751819aebb61ff15cc438e9d80d7b32d6cef4f266a1145a7037cbbfd693/setuptools-71.0.0.tar.gz"
  sha256 "98da3b8aca443b9848a209ae4165e2edede62633219afa493a58fbba57f72e2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d554090b116dad68e3bd00ee83bab733fde3ef6f58961f02275523058185567d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d554090b116dad68e3bd00ee83bab733fde3ef6f58961f02275523058185567d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d554090b116dad68e3bd00ee83bab733fde3ef6f58961f02275523058185567d"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e026b3308c8f3acd6639f4ed5c63fa255e94deaadf5c25739fb108b8a5730fb"
    sha256 cellar: :any_skip_relocation, ventura:        "0e026b3308c8f3acd6639f4ed5c63fa255e94deaadf5c25739fb108b8a5730fb"
    sha256 cellar: :any_skip_relocation, monterey:       "0e026b3308c8f3acd6639f4ed5c63fa255e94deaadf5c25739fb108b8a5730fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09c1f632cb81098c8bc2aab81dc94d53d95edbfb5f2cbbc4307b6049085d7a84"
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
