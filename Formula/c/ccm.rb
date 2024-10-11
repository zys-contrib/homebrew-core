class Ccm < Formula
  include Language::Python::Virtualenv

  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/riptano/ccm"
  url "https://files.pythonhosted.org/packages/f1/12/091e82033d53b3802e1ead6b16045c5ecfb03374f8586a4ae4673a914c1a/ccm-3.1.5.tar.gz"
  sha256 "f07cc0a37116d2ce1b96c0d467f792668aa25835c73beb61639fa50a1954326c"
  license "Apache-2.0"
  revision 4
  head "https://github.com/riptano/ccm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "39fba6eb56b8466e75887b23181ce6c3b71a9672150a3bb3d12bed1115226f4b"
    sha256 cellar: :any,                 arm64_sonoma:   "110d0383fa279c58e5f9e39fa29744036500a00fdb35e748f9097c3b018651ae"
    sha256 cellar: :any,                 arm64_ventura:  "6246dd963507a6c8f4608d9b480f9c7aa5cca92bd05d552276f3fba6dbaa967d"
    sha256 cellar: :any,                 arm64_monterey: "792c4210dd416f413530b7c00fd4ef65593f711ff3bea8bda2f9c91fe1fa7b2a"
    sha256 cellar: :any,                 sonoma:         "cb9d360a538366c88c86187ed553879039b41b109b3d0beae89d8d50fc8795da"
    sha256 cellar: :any,                 ventura:        "61cc3aa4d48862826b32c3ef498b03013a41e01f1326e9f4352d5fea4aa0ab90"
    sha256 cellar: :any,                 monterey:       "05db78bfe126a54fd81a08dd54ce4bbfd0576b73be3517f42484dbc1ccaab633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2418b3718902e783e4dd3af477e4174e52f0d696d38824530df773a26ae76d2a"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/b2/6f/d25121afaa2ea0741d05d2e9921a7ca9b4ce71634b16a8aaee21bd7af818/cassandra-driver-3.29.2.tar.gz"
    sha256 "c4310a7d0457f51a63fb019d8ef501588c491141362b53097fbc62fa06559b7c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/cf/21/58251b3de99e0b5ba649ff511f7f9e8399c3059dd52a643774106e929afa/geomet-0.2.1.post1.tar.gz"
    sha256 "91d754f7c298cbfcabd3befdb69c641c27fe75e808b27aa55028605761d17e95"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output(bin/"ccm", 1)
  end
end
