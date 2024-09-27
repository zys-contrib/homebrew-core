class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/40/63/b0883346f67d8e30eaea48c717f54f07d97e962aeae99fca7e3ed373e787/yle_dl-20240927.tar.gz"
  sha256 "ac5d6b73b1bf1816c6a03c736048286b20b2a9d8e67785c689bd3464e6252ecb"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ac4b518ee568ad6027a998ab7865a60775c04b49cfd1fbdcbe5a53fb3c28f2d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bad19e5d0bf45516e2998bcfb3859cdb1c65aaba9406b22df3ba0a91778a16b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3e450a91ff7d87d600926df7e0ab3f4cd42a644d52e96da818436c58638e158"
    sha256 cellar: :any,                 arm64_monterey: "1de9a5ccf63b004b5fa64db2142feed97ee20518e63ba20a2815573e8846f70d"
    sha256 cellar: :any_skip_relocation, sonoma:         "69d77238a756584fd72fa4b1737c8d74ed61a20fe3f87ab8b3a594b5377344fd"
    sha256 cellar: :any_skip_relocation, ventura:        "c72b69b7ecf3e0a0e1e63bf885628c86c54b1af87abe1e4c19ec83662111fa01"
    sha256 cellar: :any,                 monterey:       "a1f39a0105371462475fd626e84333d31a3ea15923572761c76d9b7d75bd7a22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9352dac3bbad3596b9796cb98f1ca988bb1557038f833362a2a13b03cd22ad1"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.12"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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
