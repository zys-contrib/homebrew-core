class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/80/08/c464b63a954f1539cd42e7e8cd6bc61d9de15c37aba4b812e705b1351a94/yle_dl-20250316.tar.gz"
  sha256 "7667a6365fe85140acd3d4378be142ce468e18c5b650d5ed04e3ff5dfd8e946f"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea04e3bf7edbf2f143e8f00b77ad87a928af6c80f458a6a859a8e1f8a831a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8491d1eb4d6f99d4902f17035128a85196b98f5f9bfab010e65f4c01a939e062"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee8721b778801bccd90e87272c0156c16b4790474488b89c8179c06c63afa9b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fe6b29a8f8a909f1e20c562d10d12cadab9000abe85f7804ea7155e1136ef59"
    sha256 cellar: :any_skip_relocation, ventura:       "ea8d60211f01ada6ff57053ef31e0cd6c9a5be8e44b345345dd939a515bd74e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f4e4ec543f127537dacd22d002ba0e3bbeb8da1e1b344c02ff584c6002b94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091cc5cf7736496e1335cf1ca8d8c4822c88c3c25e891c9d166083b5ea9ae751"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.13"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/85/4d/6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5d/configargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end
