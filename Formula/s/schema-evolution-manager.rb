class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.52.tar.gz"
  sha256 "41ec749c436d7b802731090c428120e642db89ea1ef3fd3d921a0f97ac65d800"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "532e903f99eb00a35648b9d46296d45d002765650d73b879f963262314629f4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "532e903f99eb00a35648b9d46296d45d002765650d73b879f963262314629f4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "532e903f99eb00a35648b9d46296d45d002765650d73b879f963262314629f4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "532e903f99eb00a35648b9d46296d45d002765650d73b879f963262314629f4a"
    sha256 cellar: :any_skip_relocation, ventura:        "532e903f99eb00a35648b9d46296d45d002765650d73b879f963262314629f4a"
    sha256 cellar: :any_skip_relocation, monterey:       "532e903f99eb00a35648b9d46296d45d002765650d73b879f963262314629f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea19ecdd41782c60a1060c2512b3726e98cfc419a37f40ba1172871fe1e2081f"
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
