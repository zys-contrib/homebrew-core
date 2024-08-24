class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  # NOTE: 2.7 is a development version. See:
  # https://www.isc.org/download/#Kea
  url "https://ftp.isc.org/isc/kea/2.6.1/kea-2.6.1.tar.gz"
  sha256 "d2ce14a91c2e248ad2876e29152d647bcc5e433bc68dafad0ee96ec166fcfad1"
  license "MPL-2.0"

  head do
    url "https://gitlab.isc.org/isc-projects/kea.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "log4cplus"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"keactrl", "status"
  end
end
