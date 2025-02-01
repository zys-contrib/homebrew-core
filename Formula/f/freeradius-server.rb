class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_7.tar.gz"
  sha256 "ebb906a236a8db71ba96875c9e53405bc8493e363c3815af65ae829cb6c288a3"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "d8273c1e4724a8889b45df7127dc8bc0f9e2311d521d4c37d88d0b60e4268f45"
    sha256 arm64_sonoma:  "550ad29d70fda795a136f5a68a4985a39457608daaed3e8793095bbc239037d3"
    sha256 arm64_ventura: "ea53fcee6f0448a54b68658d3251b7bd47654dbca51b5994464749b50db13ae9"
    sha256 sonoma:        "86e0e4e80f9ca6e4b01fa22c6886a6063acb626305976425508196130e39c8cf"
    sha256 ventura:       "631343eab2dd4aa02175a17c3593a2effcf441e9df705f78562c83eb8565459e"
    sha256 x86_64_linux:  "54af2578552e86f51d43f76f2892e387c71e07297f77083c01178a3ba54ca90e"
  end

  depends_on "collectd"
  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "gdbm"
    depends_on "readline"
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@3"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@3"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

    args << "--without-rlm_python" if OS.mac?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    assert_match "77C8009C912CFFCF3832C92FC614B7D1",
                 shell_output("#{bin}/smbencrypt homebrew")

    assert_match "Configuration appears to be OK",
                 shell_output("#{bin}/radiusd -CX")
  end
end
