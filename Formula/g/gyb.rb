class Gyb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "CLI for backing up and restoring Gmail messages"
  homepage "https://github.com/GAM-team/got-your-back/"
  # Check gyb.py imports for any changes. Update pypi_formula_mappings.json (if necessary)
  # and then run `brew update-python-resources gyb`.
  url "https://github.com/GAM-team/got-your-back/archive/refs/tags/v1.82.tar.gz"
  sha256 "9cd29c81c78fceebe1e7ed34627bb27d758a250ccae92aecf6bacf1da6dfed09"
  license "Apache-2.0"
  head "https://github.com/GAM-team/got-your-back.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b88d9b73764009bb028d8f50fc5aaf6ce66fa5678931723eba1a3c5ebc0a97c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b740e1ee356031cc60c20317456e4fdbccb61ea680a79344ea07fb674c6bf5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7694619e8c2f3d30cd7905ea8defee73f0c9e9ee2105034d87ca1f55658d1fa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4eff6c667a64bc798737ee7e58e0eb884c16ed085e7ebe9ea4232e2a139cc01"
    sha256 cellar: :any_skip_relocation, ventura:        "13395b1fd601bbdae4e66878979cd96991c50d90ba06349560401d983342e0c3"
    sha256 cellar: :any_skip_relocation, monterey:       "68d5958a75db5eabceb8653e68156c6808daf9205181a7bc6aecbb71d6b4ba44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e43d6608f648d0f8a30044733da655a5a6645d1eeaef5ca40bbf4a72559f92d2"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/a7/3f/ea907ec6d15f68ea7f381546ba58adcb298417a59f01a2962cb5e486489f/cachetools-5.4.0.tar.gz"
    sha256 "b8adc2e7c07f105ced7bc56dbb6dfbe7c4a00acce20e2227b3f355be89bc6827"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/c2/41/42a127bf163d9bf1f21540a3bf41c69b231b88707d8d753680b8878201a6/google-api-core-2.19.1.tar.gz"
    sha256 "f4695f1e3650b316a795108a76a1c416e6afb036199d1c1f1f110916df479ffd"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/23/7a/2c98d0454a7f59199be817a043d694a7d4f89febb022ef24ea062722a0fe/google_api_python_client-2.140.0.tar.gz"
    sha256 "0bb973adccbe66a3d0a70abe4e49b3f2f004d849416bfec38d22b75649d389d8"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/28/4d/626b37c6bcc1f211aef23f47c49375072c0cb19148627d98c85e099acbc8/google_auth-2.33.0.tar.gz"
    sha256 "d6a52342160d7290e334b4d47ba390767e4438ad0d45b7630774533e82655b95"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/cc/0f/1772edb8d75ecf6280f1c7f51cbcebe274e8b17878b382f63738fd96cee5/google_auth_oauthlib-1.2.1.tar.gz"
    sha256 "afd0cad092a2eaa53cd8e8298557d6de1034c6cb4a740500b5357b648af97263"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/0b/1a/41723ae380fa9c561cbe7b61c4eef9091d5fe95486465ccfc84845877331/googleapis-common-protos-1.63.2.tar.gz"
    sha256 "27c5abdffc4911f28101e635de1533fb4cfd2c37fbaa9174587c799fac90aa87"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/3e/fc/e9a65cd52c1330d8d23af6013651a0bc50b6d76bcbdf91fae7cd19c68f29/proto-plus-1.24.0.tar.gz"
    sha256 "30b72a5ecafe4406b0d339db35b56c4059064e69227b8c3bda7462397f966445"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/1b/61/0671db2ab2aee7c92d6c1b617c39b30a4cd973950118da56d77e7f397a9d/protobuf-5.27.3.tar.gz"
    sha256 "82460903e640f2b7e34ee81a947fdaad89de796d324bcbc38ff5430bcdead82c"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/4a/a3/d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0d/pyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/f7/00/e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971/pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    python3 = "python3.12"

    # change user config location from default of executable own path
    inreplace "gyb.py", "default=getProgPath()",
                        "default='#{pkgetc}'"

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    rw_info = python_shebang_rewrite_info(libexec/"bin/python")
    rewrite_shebang rw_info, "gyb.py"
    bin.install "gyb.py" => "gyb"
    (libexec/Language::Python.site_packages(python3)).install buildpath.glob("*.py")
  end

  def post_install
    pkgetc.mkpath
  end

  def caveats
    <<~EOS
      Default config_folder: #{pkgetc}
    EOS
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/gyb --version 2>&1")
    # Below throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "ERROR: --email is required.", shell_output(bin/"gyb", 1)
  end
end
