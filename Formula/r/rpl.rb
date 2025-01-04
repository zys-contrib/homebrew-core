class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/8d/41/b122e853b64ce9e539be9cb69e5955f73ba0b096d2ced15f5e56db6eada8/rpl-1.16.tar.gz"
  sha256 "b81a732987dd1aeda3d5911ac384cdd5f1fe5bd54bac97fb6bceefcd90415376"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dad4ab4a2e6499b351a9810927238c86e845914a4704e1d8b90006ff58f81c67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e2d9ef725b9958789e8be6289991f41860e36bd698692b3847b2a5aa5c87494"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d32ea48792da526f31c50274047ad1552d12e6d6e2ce141ffb2c0f8d4cf4b379"
    sha256 cellar: :any_skip_relocation, sonoma:        "57400d05345044f6ddc33fc40396e2e335b1cb894abd2b489693043859b39f92"
    sha256 cellar: :any_skip_relocation, ventura:       "669ac7a78dc10e7dbafbffc0a5e91ecec53b9e86e01bcfc9612b5d5c1bf5cab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc886c7312e09183d3035bf33bfbb985d98593ae88e3ec4f707bbc12c2ba3943"
  end

  depends_on "python@3.13"

  resource "chainstream" do
    url "https://files.pythonhosted.org/packages/a5/cc/93357fd1f53c61fdc6111a6d9ea2cc565b2c1be9227c15bb036a0db0396b/chainstream-1.0.2.tar.gz"
    sha256 "b32975d3b3d1c030a507ac298044c28fa3ca30d527abdfae281edd53276617b3"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test").write "I like water."

    system bin/"rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
