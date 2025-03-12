class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://davidesantangelo.github.io/krep/"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "5d6109fec2248b0567b699b6ca7e56f85158329041063ad368106ab4b8734cc4"
  license "BSD-2-Clause"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}")
    assert_match "Found 1 matches", output

    assert_match "krep v#{version}", shell_output("#{bin}/krep -v")
  end
end
