class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.2.tar.bz2"
  sha256 "f570640427041f4c5c5470d16eff951a7038c353ddc461b2750290ce99b2e3c2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.powerdns.com/downloads"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "5b61fa3f8184ad351bef1f2276b26c886f8d2a814925b37c536d2f735ee1f44f"
    sha256 arm64_sonoma:   "660e48a419366a19a97f2f05bd5abffdd16fc0e5ae0e1f29cc76923e8d98784a"
    sha256 arm64_ventura:  "1d36e9e6ffeba02de5e6bad5d320f9ad23f0e7bfc36cab5a1a7c6743a9f5300f"
    sha256 arm64_monterey: "8dbfe8340a87dc4306b88abeb60bcc2cf1eff2459c48adf5bd456d56df696963"
    sha256 sonoma:         "10e5ea6461ddddc7f7ecbdcf144566ca7466468d6f8fbd027f45e4625dfaeccf"
    sha256 ventura:        "20dfdf4113f1804649620d1ae313d62a497cc5ca91b1f353bd69480113da9bdb"
    sha256 monterey:       "ee59a163a5150373a16dde3346072919c542ac040451ac9d78ad179e41611323"
    sha256 x86_64_linux:   "391591c9b46eb4e441496ca6923e04529a137ab3734537cede69ac29f26b1c65"
  end

  head do
    url "https://github.com/powerdns/pdns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "curl"

  fails_with gcc: "5" # for C++17

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-sqlite3
      --with-modules=gsqlite3
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"pdns_server"
    keep_alive true
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1")
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
