class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://github.com/gpertea/stringtie"
  url "https://github.com/gpertea/stringtie/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "aa831451ae08f1ea524db2709d135208695bf66fc2dbcdfb3d1d8461430e2ba9"
  license "MIT"
  head "https://github.com/gpertea/stringtie.git", branch: "master"

  depends_on "htslib"

  def install
    args = [
      "HTSLIB=#{Formula["htslib"].opt_lib}",
      "LIBS=-L#{Formula["htslib"].opt_lib} -lhts -lm",
    ]
    system "make", "release", *args
    bin.install "stringtie"
  end

  test do
    resource "homebrew-test" do
      url "https://github.com/gpertea/stringtie/raw/test_data/tests.tar.gz"
      sha256 "815a31b2664166faa59cdd25f0dc2da3d3dcb13e69ee644abb972a93d374ac10"
    end

    resource("homebrew-test").stage testpath
    assert_match version.to_s, shell_output("#{bin}/stringtie --version")
    system bin/"stringtie", "-o", "short_reads.out.gtf", "short_reads.bam"
    assert_path_exists "short_reads.out.gtf"
  end
end
