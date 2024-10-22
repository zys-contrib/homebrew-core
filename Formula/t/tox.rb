class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/4b/2e/57b4c79507f8278a6ed1a8afc8e609a1927bd9cc5b2f0dabfc8b67a257fd/tox-4.23.1.tar.gz"
  sha256 "dc128e1bacddf993179a120ddfc7db2f8cda7fb67c8c4bf229a716d685f23f2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cc9ce6ebd7e199fe3aa5dfe3c240d38a699830597499168828447310db5b862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cc9ce6ebd7e199fe3aa5dfe3c240d38a699830597499168828447310db5b862"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cc9ce6ebd7e199fe3aa5dfe3c240d38a699830597499168828447310db5b862"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0038e80d7b1c867895182b2b00213493435e3c44d6a4207b642f595c49127d3"
    sha256 cellar: :any_skip_relocation, ventura:       "c0038e80d7b1c867895182b2b00213493435e3c44d6a4207b642f595c49127d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efb03cb9859c6799088e96f932220aa9794829d0c285ee7b583885002615ce55"
  end

  depends_on "python@3.13"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c3/38/a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7/cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/bb/19/441e0624a8afedd15bbcce96df1b80479dd0ff0d965f5ce8fde4f2f6ffad/pyproject_api-1.8.0.tar.gz"
    sha256 "77b8049f2feb5d33eefcc21b57f1e279636277a8ac8ad6b5871037b243778496"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/10/7f/192dd6ab6d91ebea7adf6c030eaf549b1ec0badda9f67a77b633602f66ac/virtualenv-20.27.0.tar.gz"
    sha256 "2ca56a68ed615b8fe4326d11a0dca5dfbe8fd68510fb6c6349163bed3c15f2b2"
  end

  def install
    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(Formula["python@3.13"].opt_bin/"python3.13").to_s.delete(".")

    system bin/"tox", "quickstart", "src"
    (testpath/"src/test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    chdir "src" do
      system bin/"tox", "run"
    end
    assert_predicate testpath/"src/.tox/py#{pyver}", :exist?
  end
end
