class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/7b/60/fd880c869c6a03768fcfe44168d7667f036e2499c8816dd106440e201332/nvchecker-2.15.1.tar.gz"
  sha256 "a2e2b0a8dd4545e83e0032e8d4a4d586c08e2d8378a61b637b45fdd4556f1167"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5ccd7d27d2b1ad527628eb2a8042fcbd67cf4c708966bd0259d269e3399be89a"
    sha256 cellar: :any,                 arm64_sonoma:   "344b6b08f4321b14758c0b807e3e9131874917920a312e77dfe054bf673c5936"
    sha256 cellar: :any,                 arm64_ventura:  "4712d70f895b55bce21491792a2f7e5dfe4946faa590ae95e34f9b4524c3cd92"
    sha256 cellar: :any,                 arm64_monterey: "91e4397ebcc8882e8d4e299813998cd7110c690ded807b215637cba52e0e41e8"
    sha256 cellar: :any,                 sonoma:         "3801d03c3f34cf1c70ce19c8dcb90eaee17924d23c73ddb31b400b69ad48682f"
    sha256 cellar: :any,                 ventura:        "5a4b8c21fc8540743febf8d913004c7207fa448d2decd157ecc868b7c8c0657e"
    sha256 cellar: :any,                 monterey:       "32808fe993c10a4ab7de50ee0c981890134d28bb2fdd2f911682634126b9eb03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d00485828972efa74808b34d98219060fc93c96b16000c0b1a5f0f1884c4eef4"
  end

  depends_on "jq" => :test
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/c9/5a/e68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72/pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/78/a3/e811a94ac3853826805253c906faa99219b79951c7d58605e89c79e65768/structlog-24.4.0.tar.gz"
    sha256 "b27bfecede327a6d2da5fbc96bd859f114ecc398a6389d664f62085ee7ae6fc4"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/ee/66/398ac7167f1c7835406888a386f6d0d26ee5dbf197d8a571300be57662d3/tornado-6.4.1.tar.gz"
    sha256 "92d3ab53183d8c50f8204a51e6f91d18a15d5ef261e84d452800d4ff6fc504e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}/nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end
