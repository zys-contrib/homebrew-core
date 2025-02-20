class Ad < Formula
  desc "Adaptable text editor inspired by vi, kakoune, and acme"
  homepage "https://github.com/sminez/ad"
  url "https://github.com/sminez/ad/archive/refs/tags/0.3.1.tar.gz"
  sha256 "809cd09550daf38b1c4b7d19b975e6dbeb85f424f8942f20fc9cd7808c1ef196"
  license "MIT"
  head "https://github.com/sminez/ad.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2173b14ad6153e3f0ac126516ccaa1dada78fe53dff8152595e5446ecf273525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28229269cc42c121f9ddd7a690fd985a1a2cb885b16259b7047006265b9d54ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc5e94b51304fd915296a6eac2424f5cbfb6e07b5087eac866bc1f275eeea872"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cbcd0187197ffc8afb854a65b2072225babc97a48e416730301d38457245c26"
    sha256 cellar: :any_skip_relocation, ventura:       "cedb51cf770a0ec98743b9218075bb5ef957fe8ac6888e30095528bb9178a75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "051dfca0111ac70afc85a5db37641688f9530f52c3c61ae1b568fdce059cb5c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man.install buildpath/"docs/man/ad.1"
  end

  test do
    # ad is a gui application
    assert_match "ad v#{version}", shell_output("#{bin}/ad --version").strip

    # test scripts
    (testpath/"test.txt").write <<~TXT
      Hello, World!
      Goodbye, World!
      hello, John!
      Hi, Alex!
    TXT

    (testpath/"hello.ad").write <<~AD
      ,
      x/[Hh]ello, (.*)!/
      p/$1\n/
    AD

    assert_match "World\nJohn\n", shell_output("#{bin}/ad -f #{testpath}/hello.ad #{testpath}/test.txt")
  end
end
