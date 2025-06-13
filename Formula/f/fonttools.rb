class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/f1/6f/1d84f8a2765bed80d7229b3734dc402372838be6025ed44010ffd1a84607/fonttools-4.58.3.tar.gz"
  sha256 "de9df7a2a16c9df518be8a5dcf2afd6feac63e26c6d44b29d34c4b697ac09e0e"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc27f5d9b747c19f7ec7f2a1d7ee9e19a08b13216db75f9c6e6fcc92e0b898f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45d3df36ea594f41f09891ac503b957106a1a523da13aa7acd090de10447c4a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fcde00381ecdfa4bbca1a9bfe8c559594a47cc8cdb85ab854ff03deb786b36a"
    sha256 cellar: :any_skip_relocation, sonoma:        "85dc0510fed6048aa7add0a526b5e8006290c336e5a8733129573758f8c6617d"
    sha256 cellar: :any_skip_relocation, ventura:       "8b571bf397433e0b9f598176af26dfb6eada4b4834ef7ea63a5c12a8db04076f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c37810251712008faf9a621276402ad1943bdc56609137da6bfe95484bbad93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "790d18ea939dd2291866b0d679a72a9fdc5fdf116ce3a1e03a0850b6219a9a36"
  end

  depends_on "python@3.13"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/5e/7c/a8f6696e694709e2abcbccd27d05ef761e9b6efae217e11d977471555b62/zopfli-0.2.3.post1.tar.gz"
    sha256 "96484dc0f48be1c5d7ae9f38ed1ce41e3675fd506b27c11a6607f14b49101e99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.ttx"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
