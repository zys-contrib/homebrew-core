class CloudflareCli4 < Formula
  include Language::Python::Virtualenv

  desc "CLI for Cloudflare API v4"
  homepage "https://github.com/cloudflare/python-cloudflare-cli4"
  url "https://github.com/cloudflare/python-cloudflare-cli4/archive/refs/tags/2.19.4.tar.gz"
  sha256 "7a3e9b71cad0a995d59b0c3e285e1cf16bd08d9998509f44d7c321abe803d22b"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e214f0e5e14308f0fef6f3b141a99d5bc06f62ca1bf6446753d34125fe9a2100"
    sha256 cellar: :any,                 arm64_ventura:  "aa60dfee6b98a70ab7db2759487097cebfcc4a9e072791781458013a5543bb40"
    sha256 cellar: :any,                 arm64_monterey: "56e8085bb18dc0703fba593c6217ce943df2e5db3ead4b2c4925f1489bf5b7a5"
    sha256 cellar: :any,                 sonoma:         "89d92d7e22c43f6c47ab35c9d62bd1c5cbe69a7d72e774d3f1e8441785a41a96"
    sha256 cellar: :any,                 ventura:        "4de6caca8bb4af1c0b3943a7dd38fff6ada1f201508c7e8d06dd3ae0e172d89c"
    sha256 cellar: :any,                 monterey:       "c842588105813cb0225dedb2e241ee0ae47d31127407013c8861110b04d2388e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a972ca71c5dbd48d7c63776e040e23ac633758e4b619ec67eb75188a225c1984"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/b3/e02f4f397c81077ffc52a538e0aec464016f1860c472ed33bd2a1d220cc5/certifi-2024.6.2.tar.gz"
    sha256 "3cd43f1c6fa7dedc5899d69d3ad0398fd018ad1a17fba83ddaf78aa46c747516"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jsonlines" do
    url "https://files.pythonhosted.org/packages/35/87/bcda8e46c88d0e34cad2f09ee2d0c7f5957bccdb9791b0b934ec84d84be4/jsonlines-4.0.0.tar.gz"
    sha256 "0c6d2c09117550c089995247f605ae4cf77dd1533041d366351f6f298822ea74"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".cloudflare/cloudflare.cfg").write <<~EOS
      [CloudFlare]
      email = BrewTestBot@example.com
      token = 00000000000000000000000000000000
      [Work]
      token = 00000000000000000000000000000000
    EOS

    output = shell_output("#{bin}/cli4 --profile Work /zones 2>&1", 1)
    assert_match "cli4: /zones - 6111 Invalid format for Authorization header", output
    assert_match version.to_s, shell_output("#{bin}/cli4 --version 2>&1", 1)
  end
end
