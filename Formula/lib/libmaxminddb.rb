class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.12.1/libmaxminddb-1.12.1.tar.gz"
  sha256 "30f8dcdbb0df586a2780fcbca5824300d2365734cfbc464ff306751179ef62ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3d4e0e8dc919dcba38a6de6baca2ae25d4ff75348ea714c82cc2fb82a243f050"
    sha256 cellar: :any,                 arm64_sonoma:  "27330e63c22df07dc570e7d957c8b209cbf2ecefb072328fc966d4e17fb27a78"
    sha256 cellar: :any,                 arm64_ventura: "a38120ab57d6fc47fd42d02523bc254ed0c8b99eb3e10797ca1804de9422d195"
    sha256 cellar: :any,                 sonoma:        "aac0b31cc53611c237c4ff061c96da6fba693448cfaf7273214a91ddd43169d9"
    sha256 cellar: :any,                 ventura:       "e8457afa8e8350aa4386b6a6d2d139413e9ebc6e9a5deb681d1e5ab99bfe709a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1dfbbc29e0d66bdfa737c2f447b31f0abab14f2444e4530bef4624576163931"
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share/"examples").install buildpath/"t/maxmind-db/test-data/GeoIP2-City-Test.mmdb"
  end

  test do
    system bin/"mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end
