class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/e0/55/55b19b5f6625e7f1a8398e9f19e61843e4c651164cac10673edd412c0678/solc_select-1.1.0.tar.gz"
  sha256 "94fb6f976ab50ffccc5757d5beaf76417b27cbe15436cfe2b30cdb838f5c7516"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d0661908ba920dc4a4de4ea3eb27914ec0405b8adaf35cfa77bde266a1575f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94b9be9265dbfc2de30db81960d6940539f91820f3367776174221b86d4cc682"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "509c18ea54308f169f3ddb2d0bdba7d6442dc7283502f727ef5711dec262d95d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6d96ebed3035abd3c66142cbba68a650370d3db324c1d931841f268733fa7aa"
    sha256 cellar: :any_skip_relocation, ventura:       "7367e876b2ee383d66a91d944aca60b4882d23e835cdc16c9f7d748f14c28717"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d10a3240b97ebce12c0dbf0dc1ac2174080f8f5d3e90e7d1b6d10eb248c4852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "138ad09ef8f2a22eb9b254ae878cad4f3bbd7132dea5b1f1be418365d9ac8390"
  end

  depends_on "python@3.13"

  conflicts_with "solidity", because: "both install `solc` binaries"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/44/e6/099310419df5ada522ff34ffc2f1a48a11b37fc6a76f51a6854c182dbd3e/pycryptodome-3.22.0.tar.gz"
    sha256 "fd7ab568b3ad7b77c908d7c3f7e167ec5a8f035c64ff74f10d47a4edd043d723"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"solc-select", "install", "0.5.7"
    system bin/"solc-select", "install", "0.8.0"
    system bin/"solc-select", "use", "0.5.7"

    assert_match(/0\.5\.7.*current/, shell_output("#{bin}/solc-select versions"))

    # running solc itself requires an Intel system or Rosetta
    return if Hardware::CPU.arm?

    assert_match("0.5.7", shell_output("#{bin}/solc --version"))
    with_env(SOLC_VERSION: "0.8.0") do
      assert_match("0.8.0", shell_output("#{bin}/solc --version"))
    end
  end
end
