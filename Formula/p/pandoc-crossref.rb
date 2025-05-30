class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.20.tar.gz"
  sha256 "935d66e4b52323aba625b2bfa90abfea774816ccf4feb959e8271beac6d9b453"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "570c34609bfb879e26ab1b88cb63d7bddba8bad9c782da15fc0c591304be3a2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46a66c09ddac4e7410fe41ac7d894044c5c6645fd2c14917bc6d7b87d1503730"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a7ad17fbddf9c286c599b05aab28bf3c8299bca430cb007b50d8903d8acd43e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1da76348bb932bdde1e0ddb17518a72cd83530780f8f117291bb38a6c283f33f"
    sha256 cellar: :any_skip_relocation, ventura:       "ddfd9654d4c2d91be50ece83be9fe99d1956a031371a4a500b815cd245484dc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62547c04177a060f949fb71e0494daa046bbd042aba0bd92c69f441ecec76f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "905e08c21227d57747654cf8e48e11250376453d22212a0dbabc66d3ee68ef23"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    rm("cabal.project.freeze")

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
