class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/18/22/d5af1716b40e5c27755612ad6edc0589cfe01b5e9f887bb707e3ccbdeb2c/translate_toolkit-3.14.8.tar.gz"
  sha256 "b450d7173fb8fdde094f59cc9ef0b698c9ef8825659930dd9392a92c97c7a82a"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10cf0c5539df791606f941ef118dac55b04953781690815752c324ef9f6035f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0929335da1c4146c7beec962bca016b93c8dc299fedd242b2f0b1db26cf38b94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a25b27dc218f824c616fcedc09b9055c7cb5d42b322dd734ab08f855f290039e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1acf577821de796bef04d1e30a0304b35fd9b594dea60db509255b535330e400"
    sha256 cellar: :any_skip_relocation, ventura:       "832dcfa99f899abe7e263676b95c63efcb53440f6458940e38d95382a098b115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "983d1a1389fb9d96654afd94b2cd59087bd28cd469aaeeaf31b94177f2e45aef"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/23/76/03fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152/cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
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
