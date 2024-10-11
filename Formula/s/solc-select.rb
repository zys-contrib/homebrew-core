class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/60/a0/2a2bfbbab1d9bd4e1a24e3604c30b5d6f84219238f3c98f06191faf5d019/solc-select-1.0.4.tar.gz"
  sha256 "db7b9de009af6de3a5416b80bbe5b6d636bf314703c016319b8c1231e248a6c7"
  license "AGPL-3.0-only"
  revision 2
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0295fbf24c37c60b2216666c065981534b663cfb8adf5301619f9a637971223b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcf2eda0e30f6361041ed6d3a9cf058c0621ac9b3aaf32953c6cb5f3bb321378"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3a72a574989a15328910c3339eb1840aba5b7a84375859ca0bd6835d96b16b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c7d8c394a4831a52da179c98fc476386433dcd18205314b0f9bd21b63600609"
    sha256 cellar: :any_skip_relocation, sonoma:         "0af1d0beb9c4c438b2c2983bc6e8598997417da0e7e4971a2f2d706d1c5fcb92"
    sha256 cellar: :any_skip_relocation, ventura:        "b699007b5b946854167d61d4973d658277ec09da13efc8d7888813faec4295d2"
    sha256 cellar: :any_skip_relocation, monterey:       "34f1dc7cffa7cb317316d6a00e0d44dc8e34b9395974062e7be8abf26575a7f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ef9d77fd4f6823091b8a867632c9c5b935c0d0458bd104824eb28deb49e9cd"
  end

  depends_on "python@3.13"

  conflicts_with "solidity", because: "both install `solc` binaries"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/13/52/13b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6/pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
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
