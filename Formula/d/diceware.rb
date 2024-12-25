class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/8b/ba/db6c087f044f6a753a85c0d8b25848122018ced2130061298c0c08940a54/diceware-1.0.1.tar.gz"
  sha256 "54b690809f0c56ab3085a18e15a0c3804d4a0d127f38aef0b5cf5f859d0f6639"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f17c9121b238f41d6012a411a6090ce1c8aa2ae10a3fef3532edffabae11d32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f17c9121b238f41d6012a411a6090ce1c8aa2ae10a3fef3532edffabae11d32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f17c9121b238f41d6012a411a6090ce1c8aa2ae10a3fef3532edffabae11d32"
    sha256 cellar: :any_skip_relocation, sonoma:        "830f9b138785e9311818324ced8b1abfd6a729f2db08d92cfada485ca4932af0"
    sha256 cellar: :any_skip_relocation, ventura:       "830f9b138785e9311818324ced8b1abfd6a729f2db08d92cfada485ca4932af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f17c9121b238f41d6012a411a6090ce1c8aa2ae10a3fef3532edffabae11d32"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
    man1.install "diceware.1"
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
