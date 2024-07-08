class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.50.tar.gz"
  sha256 "7e84bdb1f7260276254c4bf9942759aa480ca01fe11b81167b6ff736c31765f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ac1ec508afeeeab2339bb37433d0e23d840bc8217f2cd358eb2d6000cdbfccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ac1ec508afeeeab2339bb37433d0e23d840bc8217f2cd358eb2d6000cdbfccc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ac1ec508afeeeab2339bb37433d0e23d840bc8217f2cd358eb2d6000cdbfccc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ac1ec508afeeeab2339bb37433d0e23d840bc8217f2cd358eb2d6000cdbfccc"
    sha256 cellar: :any_skip_relocation, ventura:        "2ac1ec508afeeeab2339bb37433d0e23d840bc8217f2cd358eb2d6000cdbfccc"
    sha256 cellar: :any_skip_relocation, monterey:       "2ac1ec508afeeeab2339bb37433d0e23d840bc8217f2cd358eb2d6000cdbfccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f4da8c106298975f85975d237bc7bf2c3ecca621f1c25be376166c9e6036419"
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
