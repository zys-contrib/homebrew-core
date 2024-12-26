class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.15.0/rtorrent-0.15.0.tar.gz"
  sha256 "cd2a590776974943fcd99ba914f15e92f8d957208e82b9538e680861a5c2168f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ff4cdfea0262578387a2bd2104e7f0caab74ad85853b9558b62c2bc5e7fbb64"
    sha256 cellar: :any,                 arm64_sonoma:  "7817e20a46918a4013d357c5d7d73a28f0173ebb1cb5b7c8672b7c92b05c0b7d"
    sha256 cellar: :any,                 arm64_ventura: "653b6b2302dff61a612e18f8d48fbe79ac8d9d3797b0025b31097964c648a91b"
    sha256 cellar: :any,                 sonoma:        "9f3eca223df05e8dd831e6ba42bd6bc900e5289d7f76fca37b491dc1cf3dd1b3"
    sha256 cellar: :any,                 ventura:       "c74da101ca3e057601ff89d00cfe1d5dcb9e95cae0487483d5c1e6cb1f274b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f59d9720aa571fe2d1b44637fa114cca245154452bb7fd52a50c972b1572093"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "libtorrent-rakshasa"
  depends_on "xmlrpc-c"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-xmlrpc-c", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    pid = spawn bin/"rtorrent", "-n", "-s", testpath
    sleep 10
    assert_path_exists testpath/"rtorrent.lock"
  ensure
    Process.kill("HUP", pid)
  end
end
