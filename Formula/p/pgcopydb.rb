class Pgcopydb < Formula
  desc "Copy a Postgres database to a target Postgres server"
  homepage "https://github.com/dimitri/pgcopydb"
  url "https://github.com/dimitri/pgcopydb/archive/refs/tags/v0.17.tar.gz"
  sha256 "7ed96f7bbc0a5250f3b73252c3a88d665df9c8101a89109cde774c3505882fdf"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgcopydb.git", branch: "main"

  depends_on "sphinx-doc" => :build
  depends_on "bdw-gc"
  depends_on "libpq"

  def install
    system "make", "bin"
    libexec.install "src/bin/pgcopydb/pgcopydb"

    (bin/"pgcopydb").write_env_script libexec/"pgcopydb", PATH: "#{Formula["libpq"].opt_bin}:$PATH"

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*"]
  end

  test do
    assert_match 'Failed to export a snapshot on "postgresql://example.com"',
                 shell_output("#{bin}/pgcopydb clone --source postgresql://example.com " \
                              "--target postgresql://example.com 2>&1", 12)
  end
end
