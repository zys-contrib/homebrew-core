class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/90/34/f6361dc1c72a5a6ba83f3c65ddceed00a986bd92bf7add1603c3d76de3b9/dxpy-0.386.0.tar.gz"
  sha256 "9568441861351bd590a2612c34137b266f63df2fab7ee0a88d566a4ee85c6128"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c765ea1a050a06efbd4d2e985548d9904cc19999b3ab40ca4c66d694fe4fecc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4a7ca556d3073af038c2370a4265de18314d932e76bf2726ac602c6610e266e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be4d934c969595797e040f8c30c10af203f6982fefc6e0ba6879cd1b68a9123c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdf8828de1a335a1cc95cf7bdd0a3d7cca34ef0d00d3e8c68929cc3765183f5f"
    sha256 cellar: :any_skip_relocation, ventura:       "17e8fe2b3fed8c610a6381fa22413d47c84fcab3c0e890c2f22816e19d2aca40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "307bbaf4323e0a7b3687077e80d914baa77294c174efec9c3ac0e9814e5aeabb"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/5f/39/27605e133e7f4bb0c8e48c9a6b87101515e3446003e0442761f6a02ac35e/argcomplete-3.5.1.tar.gz"
    sha256 "eb1ee355aa2557bd3d0145de7b06b2a45b0ce461e1e7813f5d066039ab4177b4"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/26/10/2a30b13c61e7cf937f4adf90710776b7918ed0a9c434e2c38224732af310/psutil-6.1.0.tar.gz"
    sha256 "353815f59a7f64cdaca1c0307ee13558a0512f6db064e92fe833784f08539c7a"
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
