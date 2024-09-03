class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/27/cb/e754933c1ca726b0d99980612dc9da2886e76c83968c246cfb50f491a96b/setuptools-74.1.1.tar.gz"
  sha256 "2353af060c06388be1cecbf5953dcdb1f38362f87a2356c480b6b4d5fcfc8847"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5ec798244d2c2161d1717f6e465bc76ceb448873ed166738af177abc4322360"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5ec798244d2c2161d1717f6e465bc76ceb448873ed166738af177abc4322360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5ec798244d2c2161d1717f6e465bc76ceb448873ed166738af177abc4322360"
    sha256 cellar: :any_skip_relocation, sonoma:         "005753add6226ccd52841428177932e3c34619cead2bf3e52bd59031317e447a"
    sha256 cellar: :any_skip_relocation, ventura:        "005753add6226ccd52841428177932e3c34619cead2bf3e52bd59031317e447a"
    sha256 cellar: :any_skip_relocation, monterey:       "005753add6226ccd52841428177932e3c34619cead2bf3e52bd59031317e447a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304c73a61d8de60d0630efbc67103f2efa311ea26598d26deb7008db5d24455a"
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
