class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/7c/18/beed941165689e5462c8294d2e4bc165570bb0a0e8961d9445cc26e45f06/svtplay_dl-4.107.tar.gz"
  sha256 "c029e0f8e2782484e72eb83c69f4fca3254ace3cd3242919ad0e8bb9d84841e5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c62fa84bee7750e82122e2d5e521d5ed7973d5383d4ce2d6e49370cea26eb4b6"
    sha256 cellar: :any,                 arm64_sonoma:  "36cc3366d5a064892b79dae8cbd303e6c6caaad69820ebaf07bb43aed9cedfa7"
    sha256 cellar: :any,                 arm64_ventura: "0f3f6c9c23636fe5c2d440d866d98648e12520f1686a98ae1db059397a7f6d29"
    sha256 cellar: :any,                 sonoma:        "39afa85885fe03c80261ab77a70733423cb0df42745a8c003cce7168f8c8c406"
    sha256 cellar: :any,                 ventura:       "19bb9c6e35a2e040db7c2f1875fe2af441b3b08e89ff12451438016d59827ca6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5f1c1439c56947a56bd8400acfe5cb3361a83716bdc5e9a11340877d06e614e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b256314b9c4a6c4e912e2cc70fa74941489e67d1d820febf27aba5cb57f0b57d"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To use post-processing options:
        `brew install ffmpeg` or `brew install libav`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/video/357803"
    match = "https://amd-ab.akamaized.net/ab/vod/2023/07/64b249d222f325d618162f76/720_3500_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
