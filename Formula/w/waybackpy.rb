class Waybackpy < Formula
  include Language::Python::Virtualenv

  desc "Wayback Machine API interface & command-line tool"
  homepage "https://pypi.org/project/waybackpy/"
  url "https://files.pythonhosted.org/packages/34/ab/90085feb81e7fad7d00c736f98e74ec315159ebef2180a77c85a06b2f0aa/waybackpy-3.0.6.tar.gz"
  sha256 "497a371756aba7644eb7ada0ebd4edb15cb8c53bc134cc973bf023a12caff83f"
  license "MIT"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "309dcaa991b1b4ffbe5cdad23f1e4ee7775c6929489065bceb1ad4073dc808bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "562c7420ef116278819bb57b4e25b7b630ca8f5fd7ba648bb86981f8c3d2dc52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2758b56cfd854b0ee2414df6ec666e156934a8f94a3ca168a0ac9ccc9fd2c5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba628812403ae37b610c60449c1b6c1df037aaf416fe0a476b61d089e624d8ac"
    sha256 cellar: :any_skip_relocation, ventura:        "4954e2c01c0258b0a2af30a66051c3a83bc9db4b84a79399be5f3c2c58feb782"
    sha256 cellar: :any_skip_relocation, monterey:       "637bb2000269a1e02e4f1b72c294e7e460183c04eb46b5880a1a376cadc5cbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cc605112955edd0c07322915fafe260598071c6b63f58d097a6a04d0fa3ac8d"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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
    output = shell_output("#{bin}/waybackpy -o --url https://brew.sh")
    assert_match "20130328163936", output
  end
end
