class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.18.0.tar.gz"
  sha256 "907facfa672e7069aacd97ce774b18f99e689e48d6b0c1ddfe3e31b99e9429e4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71ab252eb7085e2272e0f398c5340e6b5157369ea797d470d9e5d36d83bc5aee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b78dce0feb4a6e9c476146872b4de34e6020085c2132d1b8a345fb8dd0ae0984"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1df76d3945be8f57b169749496520b1adc069136f0c5df3a7a17e08f8b4eb19"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f8415033188e12f8bb1c2651a12cd5ba8090e8547c68e96ebbfa5599c14cdb8"
    sha256 cellar: :any_skip_relocation, ventura:       "9d414e12b5c71f74c85f6961b7cded015c3271db920bd343f2e0c17e77c84ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e81485d495af9d118afb20f8ecfb014a5553847dbad7c12abd50772e599dcb8d"
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
