class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.4.0.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.4.0.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.4.0.tar.gz"
  sha256 "8e942f95a44226a012fe822faffa6c7fc38c34047add3a0c941e9bc8b8b93aa4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e227f0127449cf1a62da522a8389b1dc51b06d50fec1265be5ba400847145480"
    sha256 cellar: :any,                 arm64_sonoma:  "56baab1ce4da6812bd0db5189f9da9531605a1cdd038850d3af79aa7856ec27a"
    sha256 cellar: :any,                 arm64_ventura: "1514ff0a4545ca074ae6ed99ffe31f99f1f58646142707536b86542123635465"
    sha256 cellar: :any,                 sonoma:        "94ae96aec798073e6644baa90dadd04bb80e9409966a431edc01a2c698423277"
    sha256 cellar: :any,                 ventura:       "bfe88a30bd4b92f53e65130b0498ed4e81ec69919cde150c049d31642328e56e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87c14eaeddbcc0d0dae3d37c960a4afc37762cec25c211f60390e5b33d287acf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "zlib"

  # hfs-compression.diff has been marked by upstream as broken since 3.1.3
  # and has not been reported fixed as of 3.2.7
  patch do
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.4.0.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.4.0.tar.gz"
    sha256 "51533dc5b9b4293d3499b673df185c93484f3e6fcf2de52f9bf1f07fa3d7cbc1"
    apply "patches/fileflags.diff"
  end

  def install
    args = %W[
      --with-rsyncd-conf=#{etc}/rsyncd.conf
      --with-included-popt=no
      --with-included-zlib=no
      --enable-ipv6
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    mkdir "a"
    mkdir "b"

    ["foo\n", "bar\n", "baz\n"].map.with_index do |s, i|
      (testpath/"a/#{i + 1}.txt").write s
    end

    system bin/"rsync", "-artv", testpath/"a/", testpath/"b/"

    (1..3).each do |i|
      assert_equal (testpath/"a/#{i}.txt").read, (testpath/"b/#{i}.txt").read
    end
  end
end
