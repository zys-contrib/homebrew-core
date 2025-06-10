class CloudflareCli4 < Formula
  include Language::Python::Virtualenv

  desc "CLI for Cloudflare API v4"
  homepage "https://github.com/cloudflare/python-cloudflare-cli4"
  url "https://github.com/cloudflare/python-cloudflare-cli4/archive/refs/tags/2.19.4.tar.gz"
  sha256 "7a3e9b71cad0a995d59b0c3e285e1cf16bd08d9998509f44d7c321abe803d22b"
  license "MIT"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5e3b3f0b3816446cc8ce5ba4558cc29e6aaa28e0d5816267340a235af4f26f2b"
    sha256 cellar: :any,                 arm64_sonoma:  "7c3959d7853fcc15e1ab6b3b055f2165f531d8540e5db2d9a2592b87184924d0"
    sha256 cellar: :any,                 arm64_ventura: "e407c2dd794757e3860066d77732f6998fac507b1860362af1baaa8b5e9acf98"
    sha256 cellar: :any,                 sonoma:        "3856f20ad9c9183111715003cd046a7250909518bac616441801e94308cfcba0"
    sha256 cellar: :any,                 ventura:       "2ff0125a6ac66224dbecb0a9e7f2921ebcdf888c236b60825bbef75b1d886e55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5791a57b441f2058584a87371c09681e707592905781d1ddd80001db17db313f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9e7aa34877ea255544a9ae76e7935509fd89ba1bfde53698aca816747fd1e76"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e8/9e/c05b3920a3b7d20d3d3310465f50348e5b3694f4f88c6daf736eef3024c4/certifi-2025.4.26.tar.gz"
    sha256 "0a816057ea3cdefcef70270d2c515e4506bbc954f417fa5ade2021213bb8f0c6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jsonlines" do
    url "https://files.pythonhosted.org/packages/35/87/bcda8e46c88d0e34cad2f09ee2d0c7f5957bccdb9791b0b934ec84d84be4/jsonlines-4.0.0.tar.gz"
    sha256 "0c6d2c09117550c089995247f605ae4cf77dd1533041d366351f6f298822ea74"
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
