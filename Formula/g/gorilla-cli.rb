class GorillaCli < Formula
  include Language::Python::Virtualenv

  desc "LLMs for your CLI"
  homepage "https://gorilla.cs.berkeley.edu/"
  url "https://files.pythonhosted.org/packages/cd/2b/7a64f9ad59009e72ddf73d055195b4bf23e15599a61e66f1458b4025b9e5/gorilla-cli-0.0.10.tar.gz"
  sha256 "bf375230a06fac99ba56f14f49474466036f072751cd1d5a1908e8ace561856c"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "942159fd88e15d5d12dc10a21370ec42e2f37f89d5cfea4e0c41a277269c7610"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba57929848a6634fad2bea174d0d4352f13394521378ac1ef51a26b337fe9077"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe7da9313dcee6a2da2226d6768631db1eaf69429bf78f2796672e5bb16ab969"
    sha256 cellar: :any_skip_relocation, sonoma:         "91a3e84455a76eb7fd11860fea6117412933a5940cd811e672338ac8bbab7390"
    sha256 cellar: :any_skip_relocation, ventura:        "36efe2cbab19dd2c7cc68a617ccf310665ff1ea8cf6ff4b5c2f8e0fbc25250f5"
    sha256 cellar: :any_skip_relocation, monterey:       "45acd6e24b40ae6be7c4e6f67e336e9467fd10b8232d6aed55646e65d7a6e0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "382cc90e905b06fff9a5dc26cc8aeb9efdac82d7bf1ebab6df62f02e524b83a2"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "halo" do
    url "https://files.pythonhosted.org/packages/ee/48/d53580d30b1fabf25d0d1fcc3f5b26d08d2ac75a1890ff6d262f9f027436/halo-0.0.31.tar.gz"
    sha256 "7b67a3521ee91d53b7152d4ee3452811e1d2a6321975137762eb3d70063cc9d6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "log-symbols" do
    url "https://files.pythonhosted.org/packages/45/87/e86645d758a4401c8c81914b6a88470634d1785c9ad09823fa4a1bd89250/log_symbols-0.0.14.tar.gz"
    sha256 "cf0bbc6fe1a8e53f0d174a716bc625c4f87043cc21eb55dd8a740cfe22680556"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/47/6d/0279b119dafc74c1220420028d490c4399b790fc1256998666e3a341879f/prompt_toolkit-3.0.47.tar.gz"
    sha256 "1e1b29cb58080b1e69f207c893a1a7bf16d127a5c30c9d17a25a5d77792e5360"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "spinners" do
    url "https://files.pythonhosted.org/packages/d3/91/bb331f0a43e04d950a710f402a0986a54147a35818df0e1658551c8d12e1/spinners-0.0.24.tar.gz"
    sha256 "1eb6aeb4781d72ab42ed8a01dcf20f3002bf50740d7154d12fb8c9769bf9e27f"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/10/56/d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764/termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "config", "--global", "user.email", "BrewTestBot@example.com"
    (testpath/".gorilla-cli-userid").write "BrewTestBot"
    Open3.popen3("#{bin}/gorilla", "do", "nothing") do |stdin, stdout|
      assert_match "Welcome to Gorilla. Use arrows to select", stdout.readline
      stdin.write("\n")
    end
  end
end
