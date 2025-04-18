class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.28/xapian-omega-1.4.28.tar.xz"
  sha256 "870d2f2d7f9f0bc67337aa505fdc13f67f84cce4d93b7e5c82c7310226f0d30a"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c34abdcf680fac4d08f36815972a52c2be9cb40a225d5019bbed0cf2fdf61498"
    sha256 arm64_sonoma:  "6c1f87ad42018a1a5264505ab80b5c498dfe869a83eab41dd1fa45141a8572e5"
    sha256 arm64_ventura: "f3b3ae91e6bab172e5cb7f2f20747fdfd5e7f5d1e339a256ba007dc7015018a3"
    sha256 sonoma:        "9a12bcd4cdedd557d807684ea3a42e03040be95f1e35e92ea14347f6bac4c124"
    sha256 ventura:       "32b4c40806a017933c9079220ad77be06fae097813c8444e4a92a22bd620ba8e"
    sha256 arm64_linux:   "208ce1ee22f1e2ed0f24ab03e353b97b72e58ae16c8127b7317125c9cb1ac326"
    sha256 x86_64_linux:  "d67d137cbe14ff00b796fde6474a9f4b8550eb337f345f0f609b2192e90b5206"
  end

  depends_on "pkgconf" => :build
  depends_on "libmagic"
  depends_on "pcre2"
  depends_on "xapian"

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"omindex", "--db", "./test", "--url", "/", share/"doc/xapian-omega"
    assert_path_exists testpath/"./test/flintlock"
  end
end
