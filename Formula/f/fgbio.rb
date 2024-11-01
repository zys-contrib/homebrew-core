class Fgbio < Formula
  desc "Tools for working with genomic and high throughput sequencing data"
  homepage "https://fulcrumgenomics.github.io/fgbio/"
  url "https://github.com/fulcrumgenomics/fgbio/releases/download/2.4.0/fgbio-2.4.0.jar"
  sha256 "c8f4df9d6f4f34998e9f5d6f6533ca4fc87170247f7156d7d9705e25daee2937"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "53161ea2e9d7dbeab3949ba66e631d5184106c4c1b4b133466f8bd4eb7e5b9e5"
  end

  depends_on "openjdk"

  def install
    libexec.install "fgbio-#{version}.jar"
    bin.write_jar_script libexec/"fgbio-#{version}.jar", "fgbio"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCT
      ctgtgtggattaaaaaaagagtgtctgatagcagc
    EOS
    cmd = "#{bin}/fgbio HardMaskFasta -i test.fasta -o /dev/stdout"
    assert_match "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN", shell_output(cmd)
  end
end
