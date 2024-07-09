class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
  sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a853a3f47b0c684845bcdd6fbb403fde1ef649351fd7eb5f0e903db4b5705c00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a853a3f47b0c684845bcdd6fbb403fde1ef649351fd7eb5f0e903db4b5705c00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a853a3f47b0c684845bcdd6fbb403fde1ef649351fd7eb5f0e903db4b5705c00"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f68199f96fb597ddd7bda594338d184f96425220066938ccc5397d667d5bb52"
    sha256 cellar: :any_skip_relocation, ventura:        "8f68199f96fb597ddd7bda594338d184f96425220066938ccc5397d667d5bb52"
    sha256 cellar: :any_skip_relocation, monterey:       "8f68199f96fb597ddd7bda594338d184f96425220066938ccc5397d667d5bb52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a853a3f47b0c684845bcdd6fbb403fde1ef649351fd7eb5f0e903db4b5705c00"
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
