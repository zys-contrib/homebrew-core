class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/2f/7b/2ebe60ee2360170d93f1c3f1e4429353c8445992fc2bc501e98013697c71/diceware-0.10.tar.gz"
  sha256 "b2b4cc9b59f568d2ef51bfdf9f7e1af941d25fb8f5c25f170191dbbabce96569"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bca53edd81082b3c4948f25205a721f716b7f7c04e93b0947683293de381d60c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bade6f11a1c53d8392b0f20b367bd7bc01c39485488b7a5dacf13a7223a6dd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bade6f11a1c53d8392b0f20b367bd7bc01c39485488b7a5dacf13a7223a6dd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bade6f11a1c53d8392b0f20b367bd7bc01c39485488b7a5dacf13a7223a6dd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7d85bb88516b88f82118101047be74b214304d32cfc8428b81db6546180cf4d"
    sha256 cellar: :any_skip_relocation, ventura:        "d7d85bb88516b88f82118101047be74b214304d32cfc8428b81db6546180cf4d"
    sha256 cellar: :any_skip_relocation, monterey:       "d7d85bb88516b88f82118101047be74b214304d32cfc8428b81db6546180cf4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47e6638b7655607aa3151db297d2d8e3621f0bfb9a3d8b4af17b79a4d9fd21a9"
  end

  depends_on "python@3.13"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  def install
    virtualenv_install_with_resources
    man1.install "diceware.1"
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
