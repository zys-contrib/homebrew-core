class Skani < Formula
  desc "Fast, robust ANI and aligned fraction for (metagenomic) genomes and contigs"
  homepage "https://github.com/bluenote-1577/skani"
  url "https://github.com/bluenote-1577/skani/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "e047d52b9f753625eff480fe90f1abb68f82cc6892d9d1910b18bfcedbfc0b9d"
  license "MIT"
  head "https://github.com/bluenote-1577/skani.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "test_files"
  end

  test do
    cp_r pkgshare/"test_files/.", testpath
    output = shell_output("#{bin}/skani dist e.coli-EC590.fasta e.coli-K12.fasta")
    assert_match "complete sequence", output
  end
end
