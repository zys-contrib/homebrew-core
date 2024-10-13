class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.18.0b.tar.gz"
  version "0.3.18.0b"
  sha256 "a71043e86104951815886d560dd1173308bd7f7e556ce80530b4de03c1bcd9a5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc60d9ac437db3ab143d0187e2e725908568e160435763a8a6cf7559a9593e80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63ad7c78493feb8a4dbdb9dcc45fa7ed531494c56eda42fecd74047eb354bc61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f208e847204ebc8a3f1f8470765c780b1892440d44d81a6865371d35aa430176"
    sha256 cellar: :any_skip_relocation, sonoma:        "f749039b3879fe8f65907c18855582cca8c302127b2662a28d7957d5cee5c56c"
    sha256 cellar: :any_skip_relocation, ventura:       "ffd17991edece58bfd73e06dd6bd02dd464a00bbf68adf53b304ecf499db3a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66126f0a32093f50bee819cacb5709dc7e373a52b704b2dadd34244952cc464e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    rm("cabal.project.freeze")

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
