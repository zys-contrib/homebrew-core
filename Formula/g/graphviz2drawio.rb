class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/2d/c5/bb43966bc97368fc7eed9d8a79f0bc7eba8484cf6066f687720b616e957a/graphviz2drawio-1.0.0.tar.gz"
  sha256 "5409f11cd080b28d77408817559b6481250b3053cec757ab933b92b3075606a5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3ed2258ca2f5eda8d0d76b540519af6542502a99f27316f3a6f38d420900fdc0"
    sha256 cellar: :any,                 arm64_sonoma:   "5be0cfb80e3ba10801c328115be6cc68ba167f0e65af863feb6c7d7228dbae24"
    sha256 cellar: :any,                 arm64_ventura:  "55ec467fafe0fdc74bc3177226b0268940bfc4e51475d102d9a45ccd9cd3cf15"
    sha256 cellar: :any,                 arm64_monterey: "3a3aa4cdea5cac6cc4f735d080e0c67d3ba6fbbde1f118187a84463c49a93078"
    sha256 cellar: :any,                 sonoma:         "46b1350fb6685333d1c9f9ad56666da9d1f4a323ec51c1055d41b96b40d08df1"
    sha256 cellar: :any,                 ventura:        "712e05e48a3ff58e9ab71ba389c14e4a403bcfb9470d96eff7cc224d32698619"
    sha256 cellar: :any,                 monterey:       "74c883818508f4f771b8b691c2f8c61faab698c5439954154e09e5985256a656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b10ceff4b739cb1c69408865b485d5a0e0b456cc41473e9e8a9ac90626e6df85"
  end

  depends_on "graphviz"
  depends_on "python@3.13"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/09/2d/40599f25667733e41bbc3d7e4c7c36d5e7860874aa5fe9c584e90b34954d/puremagic-1.28.tar.gz"
    sha256 "195893fc129657f611b86b959aab337207d6df7f25372209269ed9e303c1a8c0"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/66/ca/823d5c74a73d6b8b08e1f5aea12468ef334f0732c65cbb18df2a7f285c87/pygraphviz-1.14.tar.gz"
    sha256 "c10df02377f4e39b00ae17c862f4ee7e5767317f1c6b2dfd04cea6acc7fc2bea"
  end

  resource "svg-path" do
    url "https://files.pythonhosted.org/packages/33/a0/4983cdedf62c3a1dd42b698813312fc51dd159983333fce9ec4189cd83a9/svg.path-6.3.tar.gz"
    sha256 "e937740a316a7fec86acd217ab6226e112f51328078524126bb7ea9dbe7b1ade"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "mxCell id=\"node1\"", pipe_output(bin/"graphviz2drawio", "digraph { a -> b }")

    assert_match version.to_s, shell_output("#{bin}/graphviz2drawio --version")
  end
end
