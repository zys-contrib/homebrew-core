class Trimal < Formula
  desc "Automated alignment trimming in large-scale phylogenetic analyses"
  homepage "https://trimal.readthedocs.io/"
  url "https://github.com/inab/trimal/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "3fba2e07bffb7290c34e713a052d0f0ff1ce0792861740a8cec46f40685c6d73"
  license "GPL-3.0-only"
  head "https://github.com/inab/trimal.git", branch: "trimAl"

  def install
    cd "source" do
      system "make"
      bin.install "readal", "trimal", "statal"
    end
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"trimal", "-in", "test.fasta", "-out", "out.fasta"
    assert_path_exists "out.fasta"
  end
end
