class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/69/7f/5a513d0a4cbf405ecb4657df6e268798d2cbcb9fac51b3a931d88061d330/svtplay_dl-4.97.1.tar.gz"
  sha256 "06164cf8b7f146bbd8cfdf4263d2c150e42caa39f5d7c4ced0116a40004b12aa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6beae79c3c3cfb37551e1108e899cef74b6b29b13f294e1c834736ef3301384f"
    sha256 cellar: :any,                 arm64_sonoma:   "13b5b955556305e4a194c067d9cef78a3fca2b9d814b014f765fe53e90d513b4"
    sha256 cellar: :any,                 arm64_ventura:  "db0a356f9eefeaf546201d71432766a440796bd00e8f19fe7013aa71ae6ff2a6"
    sha256 cellar: :any,                 arm64_monterey: "d2a60b903622d13a37e5057725cd420a37d2cfba7ec809f4003aeec646baa3d4"
    sha256 cellar: :any,                 sonoma:         "d6b425d3b6a62d4fd68fb881edd5f20f8eb5da4b7a3cf3132548f824e7daf1ff"
    sha256 cellar: :any,                 ventura:        "ef9a7b964f7878957d95d4b11a7b266fa7a5e155cd3096fcabcc8da1ba542c2c"
    sha256 cellar: :any,                 monterey:       "09fc160ec000325997e1a3cd6c944890a947422e9b03f520dd796c58c6ad9cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722a7ee1850147ab01fe06162f81e6cee76a618236a468fb3c178c78fcae9a9f"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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
