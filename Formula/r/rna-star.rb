class RnaStar < Formula
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  url "https://github.com/alexdobin/STAR/archive/refs/tags/2.7.11b.tar.gz"
  version "2.7.11b"
  sha256 "3f65305e4112bd154c7e22b333dcdaafc681f4a895048fa30fa7ae56cac408e7"
  license all_of: ["MIT", "BSD-2-Clause"]

  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = ["CXXFLAGS_SIMD="]
    args << "CXXFLAGSextra=-D'COMPILE_FOR_MAC'" if OS.mac?

    cd "source" do
      system "make", "STAR", *args
      bin.install "STAR"
    end
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    out = shell_output("#{bin}/STAR --runMode genomeGenerate --genomeFastaFiles test.fasta --genomeSAindexNbases 2")
    assert_match "finished successfully", out
  end
end
