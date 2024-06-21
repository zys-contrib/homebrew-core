class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/02/35/cd50421a8cb3b207650a77ca711cd411b45f48b6f619332e6ec0fd0f4d4e/dxpy-0.378.0.tar.gz"
  sha256 "fe82611e622f8a5016cee3821f337a0e20808c4a9d70da93dc900574fee2897e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24a9216051f03207317ecc7b47e2eb24860853772349e651210a4901d3d029f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "702657bc73ddeeaf32e50fd66792adcbddf9f5fa7c3b9a23c8aab2256fdeb673"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa6e65b848e0294dc46310c049e0d30a8de12417de6434341c9f9554426df466"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6ab38787dafcd31573af4e2f5327846e9a39cfa6362f5dc029e8e7b3141ad71"
    sha256 cellar: :any_skip_relocation, ventura:        "3dd897305ddd0bf158cddccfbac25fa2488d8ab73801b86c2d49dcf13659cab1"
    sha256 cellar: :any_skip_relocation, monterey:       "34df449d512a61448be490c21a20fb3fd4c7c8bd05116d84f725eb82abd35d19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db586849b1d1c09a739a0017aedb2ecac7d4dddfdb2327296d3359b01d1b1c87"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/db/ca/45176b8362eb06b68f946c2bf1184b92fc98d739a3f8c790999a257db91f/argcomplete-3.4.0.tar.gz"
    sha256 "c2abcdfe1be8ace47ba777d4fce319eb13bf8ad9dace8d085dcad6eded88057f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/20/07/2a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330/websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end
