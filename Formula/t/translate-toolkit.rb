class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/50/1e/82a0cb599821b368d16711bb13fab8f7aa3a860f8aad55464f5987b7b3fe/translate_toolkit-3.15.6.tar.gz"
  sha256 "f85a6cbb06aefb5532f4f2ee78a81f02801fc0701d6702c5e32970b76d61435c"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f617b41f160fea996469a82797c5c665c1d208dedca67821610960c3de03b76f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1464fe1e665a2e2a449f36851a211c656b105ed9b78fd5b1883a815cfe2b7df3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b1b2678a131df85f36369022d7b2390b6c25718de6744f23afad6bc20404009"
    sha256 cellar: :any_skip_relocation, sonoma:        "14424b846e3213b29fbe6e30b59eb796e71ff31452b8e4edc04b1f32b08acee6"
    sha256 cellar: :any_skip_relocation, ventura:       "99783aebc46f532619573c51a738a315d3cc1f0f36e51eee8d4cb8073cc2b154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "431064e4d2d4af15452226a59f14bae276e612c73af2f8b55880886553cd8589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb031176f9b264058116a5cf44e07daacca5e0f80a2612d49dee5caf8fcbbd0e"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/23/76/03fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152/cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/c5/ed/60eb6fa2923602fba988d9ca7c5cdbd7cf25faa795162ed538b527a35411/lxml-6.0.0.tar.gz"
    sha256 "032e65120339d44cdc3efc326c9f660f5f7205f3a535c1fdbf898b29ea01fb72"
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
