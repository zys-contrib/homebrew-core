class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia:  "74728e3cf2e16789dd3d5b8c14f3ec877a5555c49189230d8a8af02cf6fe2f15"
    sha256 cellar: :any,                 arm64_sonoma:   "a2fca7b5066ffec483e3334ee021c2165b69767e89bd883dd744107fe61a7410"
    sha256 cellar: :any,                 arm64_ventura:  "e46e133e37e80d0bf8cef00c329d6d83f2edffe4844d6b51e90d1369f0337cc7"
    sha256 cellar: :any,                 arm64_monterey: "c1483e7152c649c7599c727339e18d4c29e6b072886bd257296441f78ff9acf6"
    sha256 cellar: :any,                 sonoma:         "e8f8f7c52d3a2bf1bc3dca1a41e40981de6ebe5bfdb92942154d3719096a074e"
    sha256 cellar: :any,                 ventura:        "f1ace8ac0376b82ec336fb54f4cf00577d1c13e7a2745a0c0b8243e89c558554"
    sha256 cellar: :any,                 monterey:       "0aad2a912ab73605a010eda5e5d746ce8dffaae0fc54fd540a486426d80e235a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67e68c2e3d0fdd937eba2a890e6482cd65f7bfbd87df293660df31d78e3136b3"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/54/28/3af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472/markdown-3.7.tar.gz"
    sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write <<~EOS
      # Header 1
      ## Header 2
      ### Header 3
    EOS
    system bin/"mdv", "#{testpath}/test.md"
  end
end
