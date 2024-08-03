class Mallet < Formula
  desc "MAchine Learning for LanguagE Toolkit"
  homepage "https://mimno.github.io/Mallet/index"
  url "https://github.com/mimno/Mallet/releases/download/v202108/Mallet-202108-bin.tar.gz"
  sha256 "d64c77b00e3f1afbc48ed775f772ce7eccaaca77da4b9b581fb21dfe4a7f8a26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "66fcc304b6625b390cd2ddb5d3ab99a3049c5b21789d3b54dcc18bf82fa3c009"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.{bat,dll,exe}"] # Remove all windows files

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/mimno/Mallet/master/sample-data/stackexchange/tsv/testing.tsv"
      sha256 "06b4a0b3f27afa532ded841e8304449764a604fb202ba60eb762eaa79e9e02f3"
    end

    resource("homebrew-testdata").stage do
      system bin/"mallet", "import-file", "--input", "testing.tsv", "--keep-sequence"
      assert_equal "seconds",
        shell_output("#{bin}/mallet train-topics --input text.vectors " \
                     "--show-topics-interval 0 --num-iterations 100 2>&1").split.last
    end
  end
end
