class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.com/gitlint/"
  url "https://files.pythonhosted.org/packages/73/51/b59270264aabcab5b933f3eb9bfb022464ca9205b04feef1bdc1635fd9b4/gitlint_core-0.19.1.tar.gz"
  sha256 "7bf977b03ff581624a9e03f65ebb8502cc12dfaa3e92d23e8b2b54bbdaa29992"
  license "MIT"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "87bb06d3662dcc4dd6450caa5b854a0a90f95901284c5ec33df6709e317ef4cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e70b584b23f2d57c4a30885c40121ea9377f685d30f6954fc776c02b1e37b81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4365fab77002837b23a4327991d514c5b025f021eea344862b1f9a3ec1e00a93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee951fb0987fd209503e3407a6fdc6698b7e9cd8eb45838480275672a924fcc7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b37e4702bde58e0fc57bafa0f08e043608b9fbcebb128ab08f92469a5de61405"
    sha256 cellar: :any_skip_relocation, ventura:        "17df9675a41869eb0629903d716093caf813715c22b9f68ddaa794020b867c62"
    sha256 cellar: :any_skip_relocation, monterey:       "c58fd209e14194b759add955b3d79111dd1add1bf3669ae5b964e23289bfd40a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dea202d1fca16b893f6105f121b319cf0022f31edc89438fc9cc383c13919bff"
  end

  depends_on "python@3.13"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/52/12/b7965006c5adc57ba5459385358bd27c4983cd490884a75be86eb1d3efeb/sh-2.1.0.tar.gz"
    sha256 "7e27301c574bec8ca5bf6f211851357526455ee97cd27a7c4c6cc5e2375399cb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/31/f8/f6ee4c803a7beccffee21bb29a71573b39f7037c224843eff53e5308c16e/types-python-dateutil-2.9.0.20241003.tar.gz"
    sha256 "58cb85449b2a56d6684e41aeefb4c4280631246a0da1a719bdbe6f3fb0317446"
  end

  def install
    virtualenv_install_with_resources

    # Click does not support bash version older than 4.4
    generate_completions_from_executable(bin/"gitlint", shells:                 [:fish, :zsh],
                                                        shell_parameter_format: :click)
  end

  test do
    # Install gitlint as a git commit-msg hook
    system "git", "init"
    system bin/"gitlint", "install-hook"
    assert_predicate testpath/".git/hooks/commit-msg", :exist?

    # Verifies that the second line of the hook is the title
    output = File.open(testpath/".git/hooks/commit-msg").each_line.take(2).last
    assert_equal "### gitlint commit-msg hook start ###\n", output
  end
end
