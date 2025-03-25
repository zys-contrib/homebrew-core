class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/bb/7a/b076c1fff212bc51fab34e4d25e1e6f3dfc7412a6dd8067163f6c3750b1d/dxpy-0.393.0.tar.gz"
  sha256 "35a3d3c84831ae24b09459f7a2025ebccdc48b130170435248bdc9bccaa05e7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6c5bac12181a203c2b0652bcf2042cdb67fe48e3982766928a2f23c4fb82e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08da5a73725753d51b8c7d33e0ce1b15bf64ed42a4ccc0f4f3b688106d125b34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e352f6a4431603942ad8ed6a2c16daea641b38b631c0853d12bbbb19a93bfa4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6227f9d2bcf352d0c89384916cdf887520bc0690ea65d721b616bcef2b0dd172"
    sha256 cellar: :any_skip_relocation, ventura:       "eafa3ad03f5e46a3d16c35b207ea999ef1f3c13f4ed1b40ef7f522f7c7a8294f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04c4fe857f173c2f9640168a968307823e4ddc9b8cf5685627ed6363104afee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7b1cfb372675cf4ceb5f27342e187fab9fb7e9feecdbd98e7d9739908481c27"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/0a/35/aacd2207c79d95e4ace44292feedff8fccfd8b48135f42d84893c24cc39b/argcomplete-3.6.1.tar.gz"
    sha256 "927531c2fbaa004979f18c2316f6ffadcfc5cc2de15ae2624dfe65deaf60e14f"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/7f/4c/4e40cc26347ac8254d3f25b9f94710b8e8df24ee4dddc1ba41907a88a94d/crc32c-2.7.1.tar.gz"
    sha256 "f91b144a21eef834d64178e01982bb9179c354b3e9e5f4c803b0e5096384968c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
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
