class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/c8/c8/eec6f19c93f33a5bfbe1f5fe8f757acaa440fdb56f4209f13ef7896ea1f1/fred-py-api-1.1.3.tar.gz"
  sha256 "792760b47976f15b0e11c49944de456623e48ec67c791e03770cddca22e859f4"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "675320e55680b33458c48d949c6c20dabaeff937064d30a06a9f1e8c941d20d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90fb0f2491070fb44861fe53836f5ae688a81611c6f498f3d4d3b579a07d4f21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3efdb1b83a8ea7466e3639bc693f550917bdf32c0a6db8448f6e15cb382bc469"
    sha256 cellar: :any_skip_relocation, sonoma:         "127463b053ffa4cb29b24deaeeb6368aad24d31799732f40b48e2dae32fb7eac"
    sha256 cellar: :any_skip_relocation, ventura:        "75b6c69e4ca1ae322f0feeabee6b0571e09dad6c2e7a306e29599f4e83704463"
    sha256 cellar: :any_skip_relocation, monterey:       "778a773dacf5f16d1c7ff77aee9c4e80da4ead54a6fc7a8ce742cc9cca85d5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "073f4405c4cc293a456c0eec8a91bd26d67615b297f21d0a54633ed1861c1601"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/b3/e02f4f397c81077ffc52a538e0aec464016f1860c472ed33bd2a1d220cc5/certifi-2024.6.2.tar.gz"
    sha256 "3cd43f1c6fa7dedc5899d69d3ad0398fd018ad1a17fba83ddaf78aa46c747516"
  end

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
    # assert output & ensure exit code is 2
    # NOTE: this makes an API request to FRED with a purposely invalid API key
    invalid_api_key = "sqwer1234asdfasdfqwer1234asdfsdf"
    output = shell_output("#{bin}/fred --api-key #{invalid_api_key} categories get-category -i 15 2>&1", 2)
    assert_match "Bad Request.  The value for variable api_key is not registered.", output
  end
end
