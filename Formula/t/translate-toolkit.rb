class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/c4/8f/e703d7eb64e54b0b9f5cc4f9af6798a987acd70daf920097e1146161fdd8/translate_toolkit-3.13.1.tar.gz"
  sha256 "4f1e56668dc01fb0967d8c6fee11984869353f849036c4b1a130db64eaf26730"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f92be498a69dd91fd954ddd1765e5d7a9046a1c6f1d57676795a895b92873df6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6bacf92f41742f22a59cbdba16b190d01909f7442de25a0ebbd180d34b90e7a"
    sha256 cellar: :any,                 arm64_monterey: "ec99c46119d603f3965343dce4fe7ff3279a898840d91288d86e83bfafc71553"
    sha256 cellar: :any_skip_relocation, sonoma:         "22f3d2c282d8db6de8b18eadacc1f19f0c2b18c8da12b95760375f72e1674eea"
    sha256 cellar: :any_skip_relocation, ventura:        "70b1863e050d5c310277e8a909011bbdc743b1954332d1459a92e10c4a42f11e"
    sha256 cellar: :any,                 monterey:       "c56a54251dfde0c818ac0a6a92017015b25fb766f0570ff3eca28f094aa97188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fd4ddcd10de08244104e093aba34d6da26e95983828aae80bcb096388f48673"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
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
