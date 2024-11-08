class Iptables < Formula
  desc "Linux kernel packet control tool"
  homepage "https://www.netfilter.org/projects/iptables/index.html"
  url "https://www.netfilter.org/pub/iptables/iptables-1.8.11.tar.xz"
  sha256 "d87303d55ef8c92bcad4dd3f978b26d272013642b029425775f5bad1009fe7b2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/iptables/downloads.html"
    regex(/href=.*?iptables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 x86_64_linux: "7930259b2d467d1a20ef16973e68585075ba8734dc15bba09a203c1bfe6075ae"
  end

  depends_on "linux-headers@5.15" => :build
  depends_on "pkg-config" => :build
  depends_on "libmnl"
  depends_on "libnetfilter_conntrack"
  depends_on "libnfnetlink"
  depends_on "libnftnl"
  depends_on "libpcap"
  depends_on :linux
  depends_on "nftables"

  def install
    ENV.append "CFLAGS", "-I#{Formula["linux-headers@5.15"].opt_include}"
    system "./configure", *std_configure_args, "--disable-silent-rules",
      "--enable-bpf-compiler",
      "--enable-devel",
      "--enable-libipq",
      "--enable-shared"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Permission denied (you must be root)", shell_output("#{sbin}/iptables-nft --list-rules 2>&1", 4)
  end
end
