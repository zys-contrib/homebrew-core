class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/ba/2f/bec8195b15b6574b7ae54d436a1a712db6404e46a5005b1f304bd257a7a4/yle_dl-20250227.tar.gz"
  sha256 "6c252704d4aa4f75e4303ea26823cacebb1ba417f13e5791eea8ba09d769dd40"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "944d537bebf98ceca0b299d9aa45ace49ecf24541bfbf1e21efc00b26b7026fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83242871bdb58c0064ba29c495e3e0eb388c81cbd81db193937cbdd1b95bddd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "795dd35b2075cc69fca128ac3c6ff5dbd72958b326c0b8063b04c217a5ca4c32"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ace580f81b1131fc85ac2d35124589b3963f0c486edbfc2657e9366b156da57"
    sha256 cellar: :any_skip_relocation, ventura:       "2784da3870dfe4469ad107c1fe5e83d5f9b67a03ccf17450136c23aa4f86f055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "196878c93f4a7989c97d5df00d24250d44de71a8a507d1cf89899fb6791ea7db"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.13"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end
