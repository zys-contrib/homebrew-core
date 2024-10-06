class Honcho < Formula
  include Language::Python::Virtualenv

  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://files.pythonhosted.org/packages/65/c8/d860888358bf5c8a6e7d78d1b508b59b0e255afd5655f243b8f65166dafd/honcho-2.0.0.tar.gz"
  sha256 "af3815c03c634bf67d50f114253ea9fef72ecff26e4fd06b29234789ac5b8b2e"
  license "MIT"
  head "https://github.com/nickstenning/honcho.git", branch: "main"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "20992edea8bc84d10fb47cc1a39ec335356c39607349b11c3cd706a5ba1568a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1f50a6405f33ec30d7abc2656664197e313b5ec927214c45f343471bad8366b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7353f7b038e37a1236b3bc177f309ce63fa63ac6cc89c57664701414bdf7f38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b5a319d41ef6ed3825d96665fa038c2019897b6c193ad49e58383acc1cb00b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d78847a700cd9995001c07986b57a21853de400b3a97d07582754c107878921"
    sha256 cellar: :any_skip_relocation, ventura:        "b18d785ee4915cea8c3d06361a5a8a82a34835227fe4914f9a60c381c62e8fe1"
    sha256 cellar: :any_skip_relocation, monterey:       "f8461aa1a12f321b47368c55b126c516ff5f037c1f208b6b326787c89d54ee66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "056f4fb7815940b78ec0e81ec4b08db0dfd4a3b9665cdb71975df4a1eeef4ae6"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"Procfile").write "talk: echo $MY_VAR"
    (testpath/".env").write "MY_VAR=hi"
    assert_match(/talk\.\d+ \| hi/, shell_output("#{bin}/honcho start"))
  end
end
