class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "ad73fcf46665cba5d1639d3bae79766991ac4bbb2665b976c5819126c15ce6c7"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "3fde189e5a1a348382c1c5763b864a9a41e1a89c509252d993360c63b1a6e557"
    sha256 arm64_sonoma:  "8df92567a908112bb8f5055e525a95b5239cb89cc2acb31d114400c631bbe01d"
    sha256 arm64_ventura: "d23c663c9997cb8a46b6f2de29dbd19ceaa9987d9a2d28c06721d587e6d9d165"
    sha256 sonoma:        "3fef2264fecbf9d78e11a71355334fefc74b591985af4db8a0cad37a657bb6af"
    sha256 ventura:       "758aeb9e3628f9ed769314f9c507c8733220013a70e16a5472cc0714701fe4aa"
    sha256 x86_64_linux:  "4b1a8af15e371bc33667843f40443259f741cfe4927d3ca4c438136ae3190873"
  end

  depends_on "pkgconf" => :build
  depends_on "argon2"
  depends_on "gnutls"
  depends_on "libpq"
  depends_on "mariadb-connector-c"

  uses_from_macos "openldap"

  skip_clean "data"
  skip_clean "logs"

  def install
    ENV.cxx11
    system "./configure", "--enable-extras",
                          "argon2 ldap mysql pgsql regex_posix ssl_gnutls sslrehashsignal"
    system "./configure", "--disable-auto-extras",
                          "--distribution-label", "homebrew-#{revision}",
                          "--prefix", prefix
    system "make", "install"
  end

  test do
    assert_match("ERROR: Cannot open config file", shell_output(bin/"inspircd", 1))
  end
end
