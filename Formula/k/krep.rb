class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://davidesantangelo.github.io/krep/"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "dd29fcd022df00d32b68003b40110720ccfcd1772ccc70fca6e47229a6633ec2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df92571a01b0cf4b817717b2db8cdbf1f61abcd753f7ba306032e2d60067ac94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a69ae299744fdffda2d2ac212907988bb1ea7a1b9b08ab807bcca6e2976a0b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2145a32c4d495f3a8b3e8437efaccf2bdb10281b25cd23774cf32cba030b6f1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9350d75e47c1b857c3d952c6981c09dc50c015374b80ad4944e000de295be9f"
    sha256 cellar: :any_skip_relocation, ventura:       "791a0d318992a784ced2ec72a9fb0269707b572b5621a4e6977df4161bff40d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cccb912f0012d0c2826558f519c6c3239c4f50dd99aee26b1bd26379dd0208d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf53dd4bde0597bda16147e54e8bfba51ea0e8c5f203b3161eac5f50037c0610"
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
