class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/57/61/5bc3aff85dc5bf98291b37cf469dab74b3d0aef2dd88eade9070a200af05/sqlparse-0.5.2.tar.gz"
  sha256 "9e37b35e16d1cc652a2545f0997c1deb23ea28fa1f3eefe609eee3063c3b105f"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "36860e20591788564e5f6d79f010d2325bf0d5392aa6ffa4fa7b1a813b93eb92"
  end

  depends_on "python@3.13"

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
