class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "Identify anything: emails, IP addresses, and more"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/ae/31/57bb23df3d3474c1e0a0ae207f8571e763018fa064823310a76758eaef81/pywhat-5.1.0.tar.gz"
  sha256 "8a6f2b3060f5ce9808802b9ca3eaf91e19c932e4eaa03a4c2e5255d0baad85c4"
  license "MIT"
  revision 1
  head "https://github.com/bee-san/pyWhat.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e370395de68228f3efab43e6c91bd8e069ecda92bf6e0c4534b998e3a465f12d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab4bd8600366859bf4f0249f0fa380a62085b25163fca308da2e8c1f2a2d47e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f78a6512b3f4032d80d8cf590ed361f0adf386c457e9f223f7c33bd19c8a473"
    sha256 cellar: :any_skip_relocation, sonoma:         "77e611213fc1d827a31f3c95231b5f37e60da8ecb6547cb79d586824d11f1f04"
    sha256 cellar: :any_skip_relocation, ventura:        "ec995ec0e0ce5cb0817f7a7726920e99e32711443f5c6308eef8b0e1a19d11ea"
    sha256 cellar: :any_skip_relocation, monterey:       "4875e98f40846677d05ee488088fc8888804d1f4c3631bf46c7f1c86bf9f24ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bbdd32c04fb7efca7c7798b289b0666f5b6f9c0d17056a0e2aaf4267ba06587"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/74/c3/e55ebdd66540503cee29cd3bb18a90bcfd5587a0cf3680173c368be56093/rich-10.16.2.tar.gz"
    sha256 "720974689960e06c2efdb54327f8bf0cdbdf4eae4ad73b6c94213cad405c371b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/pywhat 127.0.0.1").strip
  end
end
