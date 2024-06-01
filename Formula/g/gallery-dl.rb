class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/12/30/9afa8353dca40bf1fd98f83deb36f52d12619b786ad028b8603da2819d0b/gallery_dl-1.26.9.tar.gz"
  sha256 "3e06dfa69c890a9805ba90509e0f0c50f8a16c39a2b780bec569d2cc2272bb99"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54cafbdd71f748d1d00991b3cb3909ce18b198fc77d573dc69b03604c5f6c619"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54cafbdd71f748d1d00991b3cb3909ce18b198fc77d573dc69b03604c5f6c619"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54cafbdd71f748d1d00991b3cb3909ce18b198fc77d573dc69b03604c5f6c619"
    sha256 cellar: :any_skip_relocation, sonoma:         "54cafbdd71f748d1d00991b3cb3909ce18b198fc77d573dc69b03604c5f6c619"
    sha256 cellar: :any_skip_relocation, ventura:        "54cafbdd71f748d1d00991b3cb3909ce18b198fc77d573dc69b03604c5f6c619"
    sha256 cellar: :any_skip_relocation, monterey:       "54cafbdd71f748d1d00991b3cb3909ce18b198fc77d573dc69b03604c5f6c619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a34063365d9d52561a73e0d678381521d3b2d2e327a6b53974dad3a981dddf8"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/d8/c1/f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16/requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    system "make", "man", "completion" if build.head?
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/gallery-dl.1"
    man5.install_symlink libexec/"share/man/man5/gallery-dl.conf.5"
    bash_completion.install libexec/"share/bash-completion/completions/gallery-dl"
    zsh_completion.install libexec/"share/zsh/site-functions/_gallery-dl"
    fish_completion.install libexec/"share/fish/vendor_completions.d/gallery-dl.fish"
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end
