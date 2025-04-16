class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "14c0d24d4bcb60fb6c412179fd58293de70b3a9b6e946ed64ff35d5ebf1fe671"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2a2830ca642dffc1c5e90e117fcc9ef4f24044d3e308a2d6d310849f5c8e7d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a802b407bf8f8476c704c63a529992b7c3f5a90718d97188655ffe55097e6ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fb444d3f3f1361ec4377d43cef4cec1a53854b691ead978b11a533394002f1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "72c753a9c5fd1391d428cfbdcac96c3c88924ac28d21b2c25616640457791d64"
    sha256 cellar: :any_skip_relocation, ventura:       "9f1a2d5509a6fca38d63e332395161f1447e9715be2459e60c79cce333667e43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f8335b2c26ca1ed5e9966ce11c5a63bf7ec64224cf8d2b462e08cc52e4c2802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f1859afb85bb80d2487c7f4ab510e66ee4f4f0d3a9de161538d48193229995b"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
