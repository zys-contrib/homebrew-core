class Showcert < Formula
  include Language::Python::Virtualenv

  desc "X.509 TLS certificate reader and creator"
  homepage "https://github.com/yaroslaff/showcert"
  url "https://files.pythonhosted.org/packages/34/dd/896f93fb0787dd7b083d9b743116801418d77907e8988084f98b7f2cf354/showcert-0.4.3.tar.gz"
  sha256 "005540cede93aaedf2f89261bcc132838b689fbb140fcad8e92c58706762f92c"
  license "MIT"
  head "https://github.com/yaroslaff/showcert.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d61e6c0796b64151868481aa13a1b4842df867a3c48df2ae7a25b77355bc7afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d61e6c0796b64151868481aa13a1b4842df867a3c48df2ae7a25b77355bc7afa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d61e6c0796b64151868481aa13a1b4842df867a3c48df2ae7a25b77355bc7afa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d679947d8db84b21361a246b5cc297cb12d6be781b10a6fdd2b240dd576a7689"
    sha256 cellar: :any_skip_relocation, ventura:       "d679947d8db84b21361a246b5cc297cb12d6be781b10a6fdd2b240dd576a7689"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d74b7b5d28fc85eab96106abcd9b4c163bda93abec72f2a6d0a3b6c0714015a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d61e6c0796b64151868481aa13a1b4842df867a3c48df2ae7a25b77355bc7afa"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "pem" do
    url "https://files.pythonhosted.org/packages/05/86/16c0b6789816f8d53f2f208b5a090c9197da8a6dae4d490554bb1bedbb09/pem-23.1.0.tar.gz"
    sha256 "06503ff2441a111f853ce4e8b9eb9d5fedb488ebdbf560115d3dd53a1b4afc73"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/showcert -h")

    assert_match "O=Let's Encrypt", shell_output("#{bin}/showcert brew.sh")

    assert_match version.to_s, shell_output("#{bin}/gencert -h")

    system bin/"gencert", "--ca", "Homebrew"
    assert_path_exists testpath/"Homebrew.key"
    assert_path_exists testpath/"Homebrew.pem"
  end
end
