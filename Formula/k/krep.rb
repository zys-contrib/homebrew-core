class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://davidesantangelo.github.io/krep/"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "a42f1d70dd1826bcfc5ffc91c9a6f52ff3e85bb47bda7b67038f549dd6c00982"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb613c2cbd2315eabfa8a1d2192aff85ccbf3736be14519d9a7452cb6699f4a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a07aaa8acc5da2b0fb3f4ae5343ba42f48fadba474024e92ae3f1cc8dc452da4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29ef0d3f225f3de7374a3538dbbaf7f02a33fa3a302a544a73fda74f8eedfb5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9486b7cbafe9a735c639e95d115f4a118b3beb852b062c0137d13dd4ccc26d7d"
    sha256 cellar: :any_skip_relocation, ventura:       "a1f64b52bb6425d2e7e551e0f063e8674f22d03732ba62f961b5eb1ab4e7a7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "955ec84c7f26cdd84f17debbdfc0d2088cd8509e4569f623bcfc8ba052f91d80"
  end

  # version patch, PR: https://github.com/davidesantangelo/krep/pull/14
  patch do
    url "https://github.com/davidesantangelo/krep/commit/d3957a2100961b29ba1259a1d2c8d4028d187e78.patch?full_index=1"
    sha256 "fcedb45bf86c870173595eb5353ca64d03fc69ff8a074043f6e198f84e13a57a"
  end

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
