class Showcert < Formula
  include Language::Python::Virtualenv

  desc "X.509 TLS certificate reader and creator"
  homepage "https://github.com/yaroslaff/showcert"
  url "https://files.pythonhosted.org/packages/da/8c/c697a22f71578fa7ebb2769ab7a8abb651f68f9a9d5719b07d4b80a7bf31/showcert-0.4.4.tar.gz"
  sha256 "cd59abab0de0f5541be2503cdeb700bbb2fb744906d28ef57c7e51d3bc2cdfce"
  license "MIT"
  head "https://github.com/yaroslaff/showcert.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d49605464727ec7dfb71f7859bea277eb0b5af731481d3ee873935055413668c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d49605464727ec7dfb71f7859bea277eb0b5af731481d3ee873935055413668c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d49605464727ec7dfb71f7859bea277eb0b5af731481d3ee873935055413668c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f7ada62f9442318e146a59d6ae3479cb4537dfec3330623063ea67427780bd7"
    sha256 cellar: :any_skip_relocation, ventura:       "9f7ada62f9442318e146a59d6ae3479cb4537dfec3330623063ea67427780bd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "071cf3454db467672ba9643674b5ad742d9382f729d20986cd657983ca4fab91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "071cf3454db467672ba9643674b5ad742d9382f729d20986cd657983ca4fab91"
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
