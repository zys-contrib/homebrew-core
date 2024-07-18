class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/55/a2/640f943c98800be626d5e4d48070e35bb891733218cf6ce562a8df53b9af/setuptools-71.0.1.tar.gz"
  sha256 "c51d7fd29843aa18dad362d4b4ecd917022131425438251f4e3d766c964dd1ad"
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
