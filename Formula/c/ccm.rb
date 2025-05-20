class Ccm < Formula
  include Language::Python::Virtualenv

  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/apache/cassandra-ccm"
  url "https://files.pythonhosted.org/packages/f1/12/091e82033d53b3802e1ead6b16045c5ecfb03374f8586a4ae4673a914c1a/ccm-3.1.5.tar.gz"
  sha256 "f07cc0a37116d2ce1b96c0d467f792668aa25835c73beb61639fa50a1954326c"
  license "Apache-2.0"
  revision 5
  head "https://github.com/apache/cassandra-ccm.git", branch: "trunk"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e036ab0817d4b65085d1c2cb6c2edf0a9e55b6340b9bbe99d6f90abc16e36e1f"
    sha256 cellar: :any,                 arm64_sonoma:  "33a2184cc7764d6ee186071d78e743b0c152cb0ac37ec5dcfe77ee3eae97ab01"
    sha256 cellar: :any,                 arm64_ventura: "a8231ecd1b2f906259979cc35186be52000c4b7786dbb55c8c3cd13c52b5402a"
    sha256 cellar: :any,                 sonoma:        "528a3299799df8daf15b07e0a0670df132ae046f0f52466defe58e968bc54a11"
    sha256 cellar: :any,                 ventura:       "9912048114592dbd5fd7be13ab693bd12c6dabe896f2b953802c383c3483e7c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a04076ec09207028fa744de13afaa744462f24fde634d9308147952e1855d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cf8010b7799a42307a71b081fdb9afa505ecc13b7ad8fa4fb826f257eafc364"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/b2/6f/d25121afaa2ea0741d05d2e9921a7ca9b4ce71634b16a8aaee21bd7af818/cassandra-driver-3.29.2.tar.gz"
    sha256 "c4310a7d0457f51a63fb019d8ef501588c491141362b53097fbc62fa06559b7c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/cd/0f/62ca20172d4f87d93cf89665fbaedcd560ac48b465bd1d92bfc7ea6b0a41/click-8.2.0.tar.gz"
    sha256 "f5452aeddd9988eefa20f90f05ab66f17fce1ee2a36907fd30b05bbb5953814d"
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
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output(bin/"ccm", 1)
  end
end
