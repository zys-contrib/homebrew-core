class PythonMatplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https://matplotlib.org/"
  url "https://files.pythonhosted.org/packages/2f/08/b89867ecea2e305f408fbb417139a8dd941ecf7b23a2e02157c36da546f0/matplotlib-3.10.1.tar.gz"
  sha256 "e8d2d0e3881b129268585bf4765ad3ee73a4591d77b9a18c214ac7e3a79fb2ba"
  license "PSF-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ea109680ad52f0a46ae78c6fc3721ae6b01656d2f20e8b7dc82a1eb30f392206"
    sha256 cellar: :any,                 arm64_sonoma:  "417255b76b6ff3027ee0a8a3301c4734d475ac6d49688f21c55b16958c2adb8d"
    sha256 cellar: :any,                 arm64_ventura: "575f7f9d6cf269728c17ed6c80733d71380bc0a3f81c94a8be49d2f1ad961f06"
    sha256 cellar: :any,                 sonoma:        "91369a90bddfa89047237d4f39318acbcd293551e2dc6f600e8da35b3a1d77fe"
    sha256 cellar: :any,                 ventura:       "5d4c75b32833904c71cf82d0f224a2a3e058727a95cc9ba59deb75f82fdc16fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59f185b8153044041d2d72f668af792c06f54d95c274187f0a9609085f70b519"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "qhull"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/25/c2/fc7193cc5383637ff390a712e88e4ded0452c9fbcf84abe3de5ea3df1866/contourpy-1.3.1.tar.gz"
    sha256 "dfd97abd83335045a913e3bcc4a09c0ceadbe66580cf573fe961f4a825efa699"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/1c/8c/9ffa2a555af0e5e5d0e2ed7fdd8c9bef474ed676995bb4c57c9cd0014248/fonttools-4.56.0.tar.gz"
    sha256 "a114d1567e1a1586b7e9e7fc2ff686ca542a82769a296cef131e4c4af51e58f4"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/82/59/7c91426a8ac292e1cdd53a63b6d9439abd573c875c3f92c146767dd33faf/kiwisolver-1.4.8.tar.gz"
    sha256 "23d5f023bdc8c7e54eb65f03ca5d5bb25b601eac4d7f1a042888a1f45237987e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8b/1a/3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2/pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def python3
    which("python3.13")
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    system python3, "-m", "pip", "--python=#{venv.root}", "install",
                                 "--config-settings=setup-args=-Dsystem-freetype=true",
                                 "--config-settings=setup-args=-Dsystem-qhull=true",
                                 *std_pip_args(prefix: false, build_isolation: true), "."

    (prefix/Language::Python.site_packages(python3)/"homebrew-matplotlib.pth").write venv.site_packages
  end

  test do
    backend = shell_output("#{python3} -c 'import matplotlib; print(matplotlib.get_backend())'").chomp
    assert_equal OS.mac? ? "macosx" : "agg", backend
  end
end
