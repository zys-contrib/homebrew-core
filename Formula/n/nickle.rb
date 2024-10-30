class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://deb.debian.org/debian/pool/main/n/nickle/nickle_2.100.tar.xz"
  sha256 "11b1521a7b9246842ee2e9bd9d239341a642253b57d0d7011d500d11e9471a2f"
  license "MIT"
  head "https://keithp.com/cgit/nickle.git", branch: "master"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nickle/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "17e29b7711e21eba1556eef58a7e18ede7084f6be1ddffd7a619247a318cb371"
    sha256 arm64_sonoma:  "4c4eabad9cbf806b46ddf0b30f2c1d7c9d32c2577a6daee75d7bfb1aa23b7f2f"
    sha256 arm64_ventura: "f84658a2e531ba8589ea8ecb6d423117e8b0d937242da37840f1322b7ca4f199"
    sha256 sonoma:        "551f5f7257ffd11b811f44950c56a98a508b446c97a8728d0cd9c10e31d1ad47"
    sha256 ventura:       "dadc319cf1e1785dd97d46c9fe5fe4e5f965a917c054ba12cd69b256ca97eac5"
    sha256 x86_64_linux:  "9f9b9f1120cdb8c39e1a28c34b821a4a0961aaa0754a338cf32248f1cd4cc62c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "flex" => :build # conflicting types for 'yyget_leng'
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  def install
    ENV["CC_FOR_BUILD"] = ENV.cc
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
