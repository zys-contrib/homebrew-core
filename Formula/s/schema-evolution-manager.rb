class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.48.tar.gz"
  sha256 "d63e1ee5160bc639d02105e87a99784010e6db760207715b0f15d185682ab99c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "528017b98ceaa5b6847d04504e1f0abe47b4c67730456968f6d42b768379bab4"
  end

  uses_from_macos "ruby"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"new.sql").write <<~EOS
      CREATE TABLE IF NOT EXISTS test (id text);
    EOS
    system "git", "init", "."
    assert_match "File staged in git", shell_output("#{bin}/sem-add ./new.sql")
  end
end
