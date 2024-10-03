class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.1.2.tar.bz2"
  sha256 "b3a37ebb20285ab9acbbb0e1370e623bb398ed3087f0e678f23ffa3b0063983d"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "c7b29389c903ddcd1d85d7bc9c4fc6b1468f1f5e7b8eacb9e61053407d339316"
    sha256 arm64_sonoma:   "34a52ef9b2313c4335c8878e5274e780fdd9722884dddde312d062c16fa83119"
    sha256 arm64_ventura:  "0979ed70f516bb36747d5e78cceabe236c529eb0bab2c9a87bd667eb929d1215"
    sha256 arm64_monterey: "dc517d5ad5484054a43c9f152f110c014ee0f81ba0e741321d3cf52805399cf8"
    sha256 sonoma:         "48fd3d137fc887a88eba5231de21a5465dbc878bf464c7ba3bcc6fecf5f0a508"
    sha256 ventura:        "fce8f838c4977d754d642556f77795c9960602205a1fc546aa6ea1dcb17f3e3c"
    sha256 monterey:       "3b681726241d5b3ac544abc4765fef828123f99a04db459518fc33b6f1847d1b"
    sha256 x86_64_linux:   "d5c09f9fb970fb35d2bed933accdd077f0dc9f3a0d9e4dd30a559888cb540f78"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
