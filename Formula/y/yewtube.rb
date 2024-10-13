class Yewtube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/yewtube"
  url "https://github.com/mps-youtube/yewtube/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "0a45b09fed598d29275f62847cbb556c948cd46d2b7bb0f6b0996b2ce05b77fe"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bad5e55244f5748877524a5e37baeb86b74b0ba28b56f1e10382ace239a3cdca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9812c083a90eec94614de37627182824071a77537eb7e87501082ccc2a7f249"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "166d140f6335a6ca3c027554d01983caa238504c414bad90312c026cd1ec8c36"
    sha256 cellar: :any_skip_relocation, sonoma:        "9153c7798f12b1def2abfc1acf634682edd654f94edf567edd32df60399bd1c4"
    sha256 cellar: :any_skip_relocation, ventura:       "1c565723218ccb1bf9c12cf2e47b50e455b6a2b102c36d59e519e286595435d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "993bd2eddc10ca7a1050f4e61e0535e8875ce81c35e80ed5b2f045c5c60c0929"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "mplayer"
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/78/49/f3f17ec11c4a91fe79275c426658e509b07547f874b14c1a526d86a83fc8/anyio-4.6.0.tar.gz"
    sha256 "137b4559cbb034c477165047febb6ff83f390fc3b20bf181c1fc0a728cb8beeb"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/b6/44/ed0fa6a17845fb033bd885c03e842f08c1b9406c86a2e60ac1ae1b9206a6/httpcore-1.0.6.tar.gz"
    sha256 "73f6dbd6eb8c21bbf7ef8efad555481853f5f6acdeaff1edb0694289269ee17f"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/11/dc/e66551683ade663b5f07d7b3bc46434bf703491dbd22ee12d1f979ca828f/pycryptodomex-3.21.0.tar.gz"
    sha256 "222d0bd05381dd25c32dd6065c071ebf084212ab79bab4599ba9e6a3e0009e6c"
  end

  resource "pylast" do
    url "https://files.pythonhosted.org/packages/bf/f2/84e992deea30c5195f7166387295049bd6b29f23a6a1a03ff8c16f59436f/pylast-5.3.0.tar.gz"
    sha256 "637943b1b0e6045dd85ed7389db6071a1fea45cc7ff90dc6126fd509ca6fae2f"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/e2/73/9223dbc7be3dcaf2a7bbf756c351ec8da04b1fa573edaf545b95f6b0c7fd/websockets-13.1.tar.gz"
    sha256 "a3b3366087c1bc0a2795111edcadddb8b3b59509d5db5d7ea3fdd69f954a8878"
  end

  resource "youtube-search-python" do
    url "https://files.pythonhosted.org/packages/91/3c/dc669b0308e49f294df67bddbb16ff3eefe5b5da6fa37ead922a8301926b/youtube-search-python-1.6.6.tar.gz"
    sha256 "4568d1d769ecd7eb4bb8365f04eec6e364c5f70eec7b3765f543daebb135fcf5"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/2e/b1/08679efb4c1932dc6420deda8a89f03d7440d6462b7f61d339db2732a497/yt_dlp-2024.10.7.tar.gz"
    sha256 "0baf1ab517c9748d7e337ced91c5543c36fc16246a9ebedac32ebf20c1998ceb"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Install the optional mpv app with Homebrew Cask:
        brew install --cask mpv
    EOS
  end

  test do
    # Fails with bot detection
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"yt",
      "set checkupdate false,",
      "set ddir \"#{testpath}\",",
      "/youtube-dl test video,", "d 1,", "q"
    downloaded_file = (testpath/"mps").children.first
    file_info = Utils.safe_popen_read("file", "--brief", downloaded_file).strip
    assert_match(/^(WebM)|(.*MP4.*)$/, file_info)
  end
end
