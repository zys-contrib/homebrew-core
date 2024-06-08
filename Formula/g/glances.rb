class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/7c/80/8eefe7e32a3aae422ed06c88c1689cdd31301c0d8ac33db913525496d1be/glances-4.0.8.tar.gz"
  sha256 "5caaf44f252d693fc9fc1e921285a207b911c62f5997d804c38541d143ee474f"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e14ed8b0a655bada3f61f1fd4a78c627417e317fc00953fbb410cd70b70c81d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f64024da68f80d832e82abeb3cd61f425f1de4d48686f05858f49f574450bcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95e175336b8fcfd87e7883e8dc5130a620fc84c935ed70a5c2741712ae74247c"
    sha256 cellar: :any_skip_relocation, sonoma:         "acccfe275ed25f8276e20290e5626ae2c252ece855363757eb5bd8cc644f02bf"
    sha256 cellar: :any_skip_relocation, ventura:        "cd48beb74172bba43979d0a458b6a7121fd279f4b2ebbeaef38e09f83c09a7b1"
    sha256 cellar: :any_skip_relocation, monterey:       "956a233e7ed4dd1eef498587ea42cf94e65f316c19bdeef4f93b61781f3c88ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "398f9bdb1e339be194a222a5983bf6073ca6c9ecd3cfc35f36181cfe52e2f3fa"
  end

  depends_on "rust" => :build # for orjson
  depends_on "python@3.12"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f8/16/c10c42b69beeebe8bd136ee28b76762837479462787be57f11e0ab5d6f5d/orjson-3.10.3.tar.gz"
    sha256 "2b166507acae7ba2f7c315dcf185a9111ad5e992ac81f2d507aac39193c2c818"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  def install
    virtualenv_install_with_resources

    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", out: write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end
