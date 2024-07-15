class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/73/82/dfa23ec2cbed08a801deab02fe7c904bfb00765256b155941d789a338c68/sqlparse-0.5.1.tar.gz"
  sha256 "bb6b4df465655ef332548e24f08e205afc81b9ab86cb1c45657a7ff173a3a00e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee42af947580da7a99717c7bd97ddf384ad28691e5e3e7849fd7e4aa5b884bc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee42af947580da7a99717c7bd97ddf384ad28691e5e3e7849fd7e4aa5b884bc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee42af947580da7a99717c7bd97ddf384ad28691e5e3e7849fd7e4aa5b884bc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee42af947580da7a99717c7bd97ddf384ad28691e5e3e7849fd7e4aa5b884bc2"
    sha256 cellar: :any_skip_relocation, ventura:        "ee42af947580da7a99717c7bd97ddf384ad28691e5e3e7849fd7e4aa5b884bc2"
    sha256 cellar: :any_skip_relocation, monterey:       "ee42af947580da7a99717c7bd97ddf384ad28691e5e3e7849fd7e4aa5b884bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52d20223df7fb8a57b7d2330a4dbe6c8930cce48ade3c999932d8f91c29141d9"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
    man1.install "docs/sqlformat.1"
  end

  test do
    expected = <<~EOS.chomp
      select *
        from foo
    EOS
    output = pipe_output("#{bin}/sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end
