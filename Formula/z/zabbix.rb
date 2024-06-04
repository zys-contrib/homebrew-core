class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/7.0/zabbix-7.0.0.tar.gz"
  sha256 "520641483223f680ef6e685284b556ba34a496d886a38dc3bca085cde21031b1"
  license "AGPL-3.0-only"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "371e6161e9cadc9906cbd98e3cd816b5b0e4c81c67e0be697f2e9f6b7cd05e05"
    sha256 arm64_ventura:  "627dcd6d843d6840320766de9d3688bb003f22e3e479b9da05cb57ac230d7f1b"
    sha256 arm64_monterey: "e163655572726b73e5f1f7060039194ef31f23a1d4c60552b079e1f204b4866a"
    sha256 sonoma:         "dd5eaf89586070bfc0d2b0050b884ba0badd3407423a2db63d26e50754b384bb"
    sha256 ventura:        "4f48ac6f6a96355f03bf0c7822092d8512a28131379d9b1708a8e638f1aafc0f"
    sha256 monterey:       "2b7012fdebc8886cf36fbf414e10495b09ca7b43444b5394edf7e4a2f8c84bc9"
    sha256 x86_64_linux:   "c6ec49b0ed8a8f7755eb45d5154f976e557a1d01274c1f8030b20a207ff39b9b"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --enable-agent
      --with-libpcre2
      --sysconfdir=#{pkgetc}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}/usr"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
