class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.51.tar.gz"
  sha256 "2aa819d1f5a7c1c850af64bc4d5bb82665018cf8629371dcc3ac40d75a21aab7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2bd09a9d037fce5321ece67cad3c08ad7c6b180bfb274dee5a5eaaa755a1bee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2bd09a9d037fce5321ece67cad3c08ad7c6b180bfb274dee5a5eaaa755a1bee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2bd09a9d037fce5321ece67cad3c08ad7c6b180bfb274dee5a5eaaa755a1bee"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2bd09a9d037fce5321ece67cad3c08ad7c6b180bfb274dee5a5eaaa755a1bee"
    sha256 cellar: :any_skip_relocation, ventura:        "f2bd09a9d037fce5321ece67cad3c08ad7c6b180bfb274dee5a5eaaa755a1bee"
    sha256 cellar: :any_skip_relocation, monterey:       "f2bd09a9d037fce5321ece67cad3c08ad7c6b180bfb274dee5a5eaaa755a1bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d8989f3ac4c98c6efc1843f12a811bd893d2aeb270da963b2baaa3275b1a072"
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
