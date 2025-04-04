class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://davidesantangelo.github.io/krep/"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "ff7f051c5bf9a2b5178ae79ae7144459569f23cbae37a548825dbc262091f7ba"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c96fdef5b61cfb38700100b6a122dc94c2d896e7bbe07ea7d1ac7c41286317c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df2bc781daabf5899653ab2db8d0fe7836fa0ba1398e5d81c3a855fff5b313b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e751a2467b94dc4e6e1f54cf7d2e96ac290e8531062908cbfa319fd25f39d879"
    sha256 cellar: :any_skip_relocation, sonoma:        "876d71f2ded9ae1e8d1d21d35a45a72c9596fe14b4d71c6132f02c7482f0026b"
    sha256 cellar: :any_skip_relocation, ventura:       "1404f3960a677ad05c250a83d632fd6035b0e2a77d45280d73e1a0ca8b25c487"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0aa78e26657e1b7145edf4cd46221b41aab0a98d06380bad1428e37623582f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaf5a518f321065a776e2c3a6a23c219370278ea25c741f4f9fd4d7c66a5e690"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/krep -v", 1)

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
