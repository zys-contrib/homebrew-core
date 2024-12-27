class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.15.0/rtorrent-0.15.0.tar.gz"
  sha256 "cd2a590776974943fcd99ba914f15e92f8d957208e82b9538e680861a5c2168f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "61c79d32b318644e254f908682647e929bdbac6234f462968b8652a772112a27"
    sha256 cellar: :any,                 arm64_sonoma:  "5f8aa62f10603cdd87eeafd364497630af8ad39f12b2318fbab9d16ab18f88d1"
    sha256 cellar: :any,                 arm64_ventura: "b8b3857405edf7261a93458afe928849c399fd0c6e66e2189bd30a2bf20afe5b"
    sha256 cellar: :any,                 sonoma:        "89260f9b78abf2ad04aafcfee603e2840f972f915823a22e2d0bdad7c8106123"
    sha256 cellar: :any,                 ventura:       "2a999a2fb4c1dff9f03b5abe895acebb2901ce0d2e6570d7c75bccfebf9efd4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6edbf0cf786d3bd45d48457d03ec8a91b4375fc17070a6facb5b698a5c53a5ef"
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
