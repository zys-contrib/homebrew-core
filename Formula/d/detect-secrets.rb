class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/69/67/382a863fff94eae5a0cf05542179169a1c49a4c8784a9480621e2066ca7d/detect_secrets-1.5.0.tar.gz"
  sha256 "6bb46dcc553c10df51475641bb30fd69d25645cc12339e46c824c1e0c388898a"
  license "Apache-2.0"
  revision 3
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5b5b89db99cf8daec3ebf6bced7ca89d5d969a632250df778b032b95a8b96ec5"
    sha256 cellar: :any,                 arm64_sonoma:  "327b43b5b499b3f31b8f98fc286e894c73991a5b6013217fb3d84675a40af59f"
    sha256 cellar: :any,                 arm64_ventura: "caf0ed6dc73cf8e77e27eb99a72866a73f092bd00ad44ad29cdc5ae00d8a750b"
    sha256 cellar: :any,                 sonoma:        "690c5daee0e9dfa3df77e892a5e596d886e8ee122f89cbeab904f1c9c2ea12eb"
    sha256 cellar: :any,                 ventura:       "81ed7a53fcc48523a232222c8da7109cc10ef63ea87122b0567ee496b97dbc7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc70345c6ad57cf1aacd5fd295e2d248bbbce24d5c35b96ac3668c47f79a17da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29102c03ff1a3507bed0d32067f4f7b6523cb8198c07c890934b19fabc4cc97c"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
