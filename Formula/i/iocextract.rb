class Iocextract < Formula
  include Language::Python::Virtualenv

  desc "Defanged indicator of compromise extractor"
  homepage "https://inquest.readthedocs.io/projects/iocextract/en/latest/"
  url "https://files.pythonhosted.org/packages/ad/4b/19934df6cd6a0f6923aabae391a67b630fdd03c12c1226377c99a747a4f1/iocextract-1.16.1.tar.gz"
  sha256 "ec1389a76a5083f643652579610e8313d27ed5821fc57e7b046c23ddec181d44"
  license "GPL-2.0-only"
  revision 6
  head "https://github.com/InQuest/iocextract.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "da885335e9050e42937ea8eb8a5d54dc4fe4590047d5a5a1a8776c5d202a69a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a794499e5c2787574777c58fdda6dcaea39d158d9f8f917a4d3fac3e24a7db75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "749af351dfeb370440926d47671fcbf851abb4fe94a93aada0983bd214aee2ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42102096bfa9365dfc6e30d2d7cb69d00020f5b4dd57fab58ec967893c1f2d2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "38144d68af886d4daf65167baf40ae9a25bed527976869f004a9bed6c10ae315"
    sha256 cellar: :any_skip_relocation, ventura:        "fc0d0a97a7ad5d1914534078d023507a5e4772412d228356ae2bd4eba7b66c85"
    sha256 cellar: :any_skip_relocation, monterey:       "c09c8397037f1dea841bcbdc6b52faa28816e65e17d5a86aa22b261f1ce0eb8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8892f0feb2a98c4d64103c4054b1b65a4e2df59d40bb773f2f30ddfac4ffb136"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write <<~EOS
      InQuest customers have had detection for threats delivered from hotfixmsupload[.]com
      since 6/3/2017 and cdnverify[.]net since 2/1/18.
    EOS

    assert_match "hotfixmsupload[.]com\ncdnverify[.]net", shell_output("#{bin}/iocextract -i #{testpath}/test.txt")
  end
end
