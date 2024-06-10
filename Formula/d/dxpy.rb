class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/72/06/a37481c20d04b08efcacb0318ab90673deaba833a6fb5b7250db21f7493d/dxpy-0.377.0.tar.gz"
  sha256 "96a2413e998c3cde8fc42d93be9d979104b0614771d02cfdea5ef1b3325b77ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17df18f9dbbf2e0a89cf3926319feee44b37c48ebe14cfae4afe37c4357fa325"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69476cc59a8183fc5e484ca43d90ab4cbfbd54c89535ef276bfb51e51a4f0fe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c61c758cc7176130520d3c850ef71b42b15ce3639f4d88c0a9f223302593eb44"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c3b3285a21f9abfe02760471ec0a451f43ba26cf7996d0982307df8d5c2d9ab"
    sha256 cellar: :any_skip_relocation, ventura:        "2b7e1049fa0a24932741737c19130e500a0ca90ac19271b1cf6f7f744759a0bd"
    sha256 cellar: :any_skip_relocation, monterey:       "157d0b342076ee67370607c7588a66ca893a1cdc7100f484eb15b20f230bc5ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cc808803278681b65711231ddfd58a18f7b50ec6d542930ebb5b32b19853bf5"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/79/51/fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587/argcomplete-3.3.0.tar.gz"
    sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
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
