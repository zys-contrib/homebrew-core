class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/34/5a/798bf4f061094e6a526b66cf020488440c2816d2aa176218918d7723785a/pspdfutils-3.3.3.tar.gz"
  sha256 "5403ea98d5131b01c541f22cac04af744a45a4658912e9f7db793fe95b5e6e9c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ae0aa9c3d86ce7b80cfbcee48c2a4849ddfe5b827d2a3f319bc72d0ae90bb20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bce0efd79698f7e24eb69835c12e718f3f371a65ebd6848c756899cd15d40330"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "796456a0c27fdddc8c80134ce8a585965659f83243d00e3c8326e6aa8e1e3b8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b597434b7a83b617e206e2b8db798b928f4de94d849d14b4e45d11b99f9936c5"
    sha256 cellar: :any_skip_relocation, ventura:        "9356f545cab5c06e5f1b4bc019df52c0522120478884650b2e1be32905c86536"
    sha256 cellar: :any_skip_relocation, monterey:       "fe2c07cd5246ad231d8a520eda16e27d5d6908ff2cc3897f45bdd74d74053605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec83b119ca6ba048d42bcf0c65366a71969834290d1d66078c7f0b2040d6d72"
  end

  depends_on "libpaper"
  depends_on "python@3.12"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/b8/6e/c8fde967ef33df3740a0af9340bdd5d77af422bb10e7abb4c56977e61907/puremagic-1.26.tar.gz"
    sha256 "ea875d3fdd6a29134bdd035cdfeca177fed575b6bdd68acd86f83ca284edc027"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/71/01/2b94d9be4ae36f30e7f980db2f05c9b92831cea87b96669d528d07f44bad/pypdf-4.2.0.tar.gz"
    sha256 "fe63f3f7d1dcda1c9374421a94c1bba6c6f8c4a62173a59b64ffd52058f846b1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test-ps" do
      url "https://raw.githubusercontent.com/rrthomas/psutils/e00061c21e114d80fbd5073a4509164f3799cc24/tests/test-files/psbook/3/expected.ps"
      sha256 "bf3f1b708c3e6a70d0f28af55b3b511d2528b98c2a1537674439565cecf0aed6"
    end
    resource("homebrew-test-ps").stage testpath

    expected_psbook_output = "[4] [1] [2] [3] \nWrote 4 pages\n"
    assert_equal expected_psbook_output, shell_output("#{bin}/psbook expected.ps book.ps 2>&1")

    expected_psnup_output = "[1,2] [3,4] \nWrote 2 pages\n"
    assert_equal expected_psnup_output, shell_output("#{bin}/psnup -2 expected.ps nup.ps 2>&1")

    expected_psselect_output = "[1] \nWrote 1 pages\n"
    assert_equal expected_psselect_output, shell_output("#{bin}/psselect -p1 expected.ps test2.ps 2>&1")
  end
end
