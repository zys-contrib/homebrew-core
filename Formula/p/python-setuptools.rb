class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/98/0b/56dabcf2b37d9152090bcd5d42e28ad312c9ba54fb1446b22dcc809dd84a/setuptools-73.0.0.tar.gz"
  sha256 "3c08705fadfc8c7c445cf4d98078f0fafb9225775b2b4e8447e40348f82597c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aca98bb0ed8587abe2c80f21be9cfd26b8080f473255d8d4c2ffb2dbeaf2d83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aca98bb0ed8587abe2c80f21be9cfd26b8080f473255d8d4c2ffb2dbeaf2d83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aca98bb0ed8587abe2c80f21be9cfd26b8080f473255d8d4c2ffb2dbeaf2d83"
    sha256 cellar: :any_skip_relocation, sonoma:         "af018f67b90d66bbdf282a49c90bfec38d79698aff6650d4849ca8a2c479c0f5"
    sha256 cellar: :any_skip_relocation, ventura:        "af018f67b90d66bbdf282a49c90bfec38d79698aff6650d4849ca8a2c479c0f5"
    sha256 cellar: :any_skip_relocation, monterey:       "af018f67b90d66bbdf282a49c90bfec38d79698aff6650d4849ca8a2c479c0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f830d1c33d280facbcf444826208833e47cdcdc9428842d557da8288141df57"
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
