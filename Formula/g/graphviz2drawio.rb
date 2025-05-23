class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/fb/e9/2ba4114579f8e708b6b5d671afe355c9b8cdd52b15a9d126ec188a2bcad6/graphviz2drawio-1.1.0.tar.gz"
  sha256 "8758b9eefbac5d8c03a0358c0158845235c9c3caa99887f0f6026cfecc2895f2"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a823fd2862aebc1b5de5a9d108b59967fbcde502a7af913534e7d19efd7ce6e0"
    sha256 cellar: :any,                 arm64_sonoma:  "1434e458a308fd5f985e4f6c4f07a4c9990e96cfcba5b5d75b914f716e118560"
    sha256 cellar: :any,                 arm64_ventura: "fbe3fdff2d2aa5347c017f76fdbabedd6e186193a6ecfb1d89c3096282f0eb28"
    sha256 cellar: :any,                 sonoma:        "2ef4e26ca63cd22697f16a72f10b049f6a3a4af8a9476bca63aec0b343208982"
    sha256 cellar: :any,                 ventura:       "e95abf496b968b6720ac814b150f9f43ebcd2ce510f3415b6e304e375aa1c488"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b3e5d4d939d4ec4ef712211f3c4fa83fc3829f2dd199aa79ca638978e2cc746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c3027d0a7344e41bab4006f7c3f422fa68dcafa519735e53a7165378f0c3e76"
  end

  depends_on "graphviz"
  depends_on "python@3.13"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/d6/de/c9dbb741a2e0e657147c6125699e4a2a3b9003840fed62528e17c87c0989/puremagic-1.29.tar.gz"
    sha256 "67c115db3f63d43b13433860917b11e2b767e5eaec696a491be2fb544f224f7a"
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
