class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.26.tar.bz2", using: :homebrew_curl
  sha256 "74641a66cc2bfae302c2a64a4b268a3db8fb0cc7364dc7975c44c57d65cd8d1c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "77b7dabe8f338886ac18e1dfce6252cc8523c16e2941590b7407815a4fa2e3b6"
    sha256 arm64_sonoma:  "badc9dbd85955d8725cbc1e9b11b04985206f5d89c35f5bd230ef341088316bc"
    sha256 arm64_ventura: "ab4c67fd62fc3c34c4648c0d76e9cc50771f2c0e9b1346616af364a2b6bea61a"
    sha256 sonoma:        "1a41b5fa5810156499ce8aeba70e24620ad492cdb1dde3e3ff4b945fe4200181"
    sha256 ventura:       "37ed9eaf7102545a3bc63e738a004d844eb8999f52f0117de02a3c95e2771486"
    sha256 x86_64_linux:  "a602ca0e46c4d6832ab3de90747f310330743343130b605835abe65528a1893c"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "unixodbc"

  uses_from_macos "krb5"

  on_linux do
    depends_on "readline"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system bin/"tsql", "-C"
  end
end
