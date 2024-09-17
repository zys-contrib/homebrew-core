class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/eralchemy/eralchemy"
  url "https://files.pythonhosted.org/packages/19/05/5f69930e83a02360d9ed16660bdd58d9d501bffabd43d7dbbe8c14269143/eralchemy-1.5.0.tar.gz"
  sha256 "fa66a3cd324abd27ad8e65908d7af48d8198c0c185aeb22189cf40516de25941"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "9d88415eca1ebcb59ff01ae4b9526ce835b6bd1f71c54ceb7e19977d6e0271ff"
    sha256 cellar: :any,                 arm64_sonoma:   "367acd7b96563e4125df8898bc2f1cb07b229bbbb04b78a321b19e1fc8c789b1"
    sha256 cellar: :any,                 arm64_ventura:  "9c97192396a1913523c7cfc518ee6992bd19190ffe648b015984f5783a026ecf"
    sha256 cellar: :any,                 arm64_monterey: "697bcb5c3612f600fa6c4792eb54ae3598478159c353d6bc727f5f5c59a3cdfe"
    sha256 cellar: :any,                 sonoma:         "7d08e2b884b797dfac455c6a727e51170d6391784bb05df88068aa9be781475a"
    sha256 cellar: :any,                 ventura:        "971c788786605ca57de3a4703ae9d6bf5769cab7cb3f4eeda30717edb0b14d23"
    sha256 cellar: :any,                 monterey:       "b692bdfec78085160b99b0c0b985513ac9be3a7186f8c13271e562c073d6c295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aa0e534f282e2a530f99e14caceced86c646d818a2092cd07d523bdb244e29d"
  end

  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python@3.12"

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/8c/41/7b9a22df38bb7884012b34f2986d765691dbe41bf5e7af881dfd09f8145f/pygraphviz-1.13.tar.gz"
    sha256 "6ad8aa2f26768830a5a1cfc8a14f022d13df170a8f6fdfd68fd1aa1267000964"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/36/48/4f190a83525f5cefefa44f6adc9e6386c4de5218d686c27eda92eb1f5424/sqlalchemy-2.0.35.tar.gz"
    sha256 "e11d7ea4d24f0a262bccf9a7cd6284c976c5369dac21db237cff59586045ab9f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "er_example" do
      url "https://raw.githubusercontent.com/Alexis-benoist/eralchemy/v1.1.0/example/newsmeme.er"
      sha256 "5c475bacd91a63490e1cbbd1741dc70a3435e98161b5b9458d195ee97f40a3fa"
    end

    system bin/"eralchemy", "-v"
    resource("er_example").stage do
      system bin/"eralchemy", "-i", "newsmeme.er", "-o", "test_eralchemy.pdf"
      assert_predicate Pathname.pwd/"test_eralchemy.pdf", :exist?
    end
  end
end
