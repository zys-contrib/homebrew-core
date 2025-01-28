class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/15/e0/709453393c0ea77d007d907dd436b3ee262e28b30995ea1aa36c6ffbccaf/codespell-2.4.1.tar.gz"
  sha256 "299fcdcb09d23e81e35a671bbe746d5ad7e8385972e65dbb833a2eaac33c01e5"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "743ad79b4e6045a50f6778b193d430d1e98d5fa56bde864696fba56c1a0aafb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "743ad79b4e6045a50f6778b193d430d1e98d5fa56bde864696fba56c1a0aafb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "743ad79b4e6045a50f6778b193d430d1e98d5fa56bde864696fba56c1a0aafb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6c275235fc65504e970a0110ca92e58350df5fa576de6edbdffe2412cf5bbc8"
    sha256 cellar: :any_skip_relocation, ventura:       "f6c275235fc65504e970a0110ca92e58350df5fa576de6edbdffe2412cf5bbc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "743ad79b4e6045a50f6778b193d430d1e98d5fa56bde864696fba56c1a0aafb5"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
