class Polypolish < Formula
  desc "Short-read polishing tool for long-read assemblies"
  homepage "https://github.com/rrwick/Polypolish"
  url "https://github.com/rrwick/Polypolish/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "99ea799352cecf6723b73fb4c5c64dd2091ff1cdab6eef10309e06c642e56855"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Polypolish.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/polypolish polish test.fasta")
    assert_match "polypolish", output
  end
end
