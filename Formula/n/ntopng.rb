class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  license "GPL-3.0-only"

  stable do
    url "https://github.com/ntop/ntopng/archive/refs/tags/6.2.tar.gz"
    sha256 "de6ef8d468be3272bce27719ab06d5b7eed6e4a33872528f64c930a81000ccd1"

    depends_on "ndpi"

    # Apply Gentoo patch to force dynamically linking nDPI
    patch do
      url "https://gitweb.gentoo.org/repo/gentoo.git/plain/net-analyzer/ntopng/files/ntopng-5.4-ndpi-linking.patch?id=25646dfc75b15c2bcc9c80ab3aba7a6bab5eec68"
      sha256 "ddbfb32a642e890878bef52c4c8e02232e9f11c132e348c78d47c7865d5649e0"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "778b00f575e753b94aa544362dde641f028932146c84f19f73076940a301b301"
    sha256 arm64_ventura:  "3a22cb20eff4ebe2ef15b69d8a384f03103f9d8024290b3d8aae96275d2eccf6"
    sha256 arm64_monterey: "88fcdf863e873ff238041e7fccf65b6bd32fb357f2f682d868b8d5394cc56428"
    sha256 sonoma:         "87ceb2c71bcbc2adfe2a5393357d477730ace4435d75bc117c507937346a71fe"
    sha256 ventura:        "e6820a187c13bf156dfb1146783cfb1bc735cba6fec26c01bbe461459d5a0ef3"
    sha256 monterey:       "e7c66db0a5c80caff9cf98da11c3e5fdbfb9aa9c3f2f129509e48dae3300672a"
    sha256 x86_64_linux:   "cf9a961dfd80df66a2ff55cf417cd4e41981cbb9464e9c877fc0bdeb61e5087a"
  end

  head do
    url "https://github.com/ntop/ntopng.git", branch: "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", branch: "dev"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "hiredis"
  depends_on "json-c"
  depends_on "libmaxminddb"
  depends_on "libsodium"
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "redis"
  depends_on "rrdtool"
  depends_on "sqlite"
  depends_on "zeromq"
  depends_on "zlib"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "libpcap"

  on_macos do
    depends_on "zstd"
  end

  on_linux do
    depends_on "libcap"
  end

  fails_with gcc: "5"

  def install
    # Remove bundled libraries
    rm_r Dir["third-party/{json-c,rrdtool}*"]

    args = []
    if build.head?
      resource("nDPI").stage do
        system "./autogen.sh"
        system "make"
        (buildpath/"nDPI").install Dir["*"]
      end
    else
      args << "--with-ndpi-includes=#{Formula["ndpi"].opt_include}/ndpi"
    end

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make", "install", "MAN_DIR=#{man}"
  end

  test do
    redis_port = free_port
    redis_bin = Formula["redis"].bin
    fork do
      exec redis_bin/"redis-server", "--port", redis_port.to_s
    end
    sleep 10

    mkdir testpath/"ntopng"
    fork do
      exec bin/"ntopng", "-i", test_fixtures("test.pcap"), "-d", testpath/"ntopng", "-r", "localhost:#{redis_port}"
    end
    sleep 30

    assert_match "list", shell_output("#{redis_bin}/redis-cli -p #{redis_port} TYPE ntopng.trace")
  end
end
