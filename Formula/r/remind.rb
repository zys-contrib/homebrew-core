class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.01.01.tar.gz"
  sha256 "f74e95f507451ca275fae5eff73ac5cfdb307de56bfe4c609202a41acb1c518d"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "ad8030a909ba1a9d757fe380adc2a8c15a5049e078ec7c8a3c5ead4df6d0ff0c"
    sha256 arm64_sonoma:  "768ccbcd28f7a02a6343b7ab3723f8b9066e2ac5209a8c03c4a748d2f6ebdf14"
    sha256 arm64_ventura: "4e99294848a77d9433165b7a1ace33cac2a61ea59950fe7d178d11771877635b"
    sha256 sonoma:        "c53db18a623d9468b34cf79c2e83e50bd60746f4a5b35c4de45e6589d3d3562b"
    sha256 ventura:       "e0c1e32e2357477ddb92cc89b6bb52728e4ad83fc5641f34a70ef99033def386"
    sha256 x86_64_linux:  "7dfc37d523bc01e6ea8dfab5b000a52b1e005871d9c8ef4e0b0ecc2d5b4fa962"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end
