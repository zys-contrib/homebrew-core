class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/f2/35/7264ad40d8ef95db2cdceadd808b479c5c289068bc2809db0ed265cc6f3c/translate_toolkit-3.15.2.tar.gz"
  sha256 "8b9cf1a6ffd3eb10757c77496c414bc6a6eb400bf88f10914257672431fe22ae"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7706fe04a633d3f7a39f01b2cfe03268ed55a122307b4b3f3aff9213e35e68f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59a3ec89a1f690cc1fee04c8b25292ba70301095c50e01fc679d1eef834ddaa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "138e675c021c3e3724dda2344d8da33c535d3bbd57664c339358caa282d29434"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5cb0577213d0c4b8c128f79f2e4bcfeaaec20f25b1d68dbcca5b9a277cfc601"
    sha256 cellar: :any_skip_relocation, ventura:       "89d12d37efe6796a66280c76020d4218f80a076bc32b8ede2c01c14aacbd4183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "818915968e3b3bf1b493ed8d271924681b03dc0fac155ffed80efd804b8c92bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c23b09e3c6e7c0933fab4964460866742ceb44dbac597d2f54c4f2d0874e5b9c"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/23/76/03fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152/cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
