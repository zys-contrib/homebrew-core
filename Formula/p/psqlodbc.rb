class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-16_00_0005.tar.gz"
  sha256 "1aa1bd5f9cb26ac1a4729ed2ab48974b29c335bebff6830d66aaac8bcd081ab0"
  license "LGPL-2.0-or-later"
  head "https://github.com/postgresql-interfaces/psqlodbc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^REL[._-]?v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1229ef358825e878796718b5a7bd690051a0e01a2a2ed927ef1360313a975a00"
    sha256 cellar: :any,                 arm64_ventura:  "f53fb9326250d633c23dfef023e69ef0597895cfbc86c8cf81848c7e9a4bfab6"
    sha256 cellar: :any,                 arm64_monterey: "28bd7e3f2aadef2bf3aca658ca50a2737269a6291244e6ad67b67a1b94467370"
    sha256 cellar: :any,                 arm64_big_sur:  "bc0dc67fbd70f40764022d62130bcb4ac56b03e54536379111861865869eccd8"
    sha256 cellar: :any,                 sonoma:         "9f9f2dd2b6978bfb5f25f70322d6fb8c80aece1017580fa31e3bf21b4162300a"
    sha256 cellar: :any,                 ventura:        "ef187668cb23144e4417b24223d1d11c36003b50f1f39d2f36cb27e7e4c6878f"
    sha256 cellar: :any,                 monterey:       "2de23c7e1ca3c02345187d4d626d23822ccbb3c2010057c0419628ab710c4e85"
    sha256 cellar: :any,                 big_sur:        "1e12c7ad493668714db01072007993ce3bd7d68959ed00eb42b5959a838dc2d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e7abbebf5c82fff0fd95e55c2af66c164ee7562dffef391c2a96e9a1a371c0c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libpq"
  depends_on "unixodbc"

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
