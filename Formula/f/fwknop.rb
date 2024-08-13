class Fwknop < Formula
  desc "Single Packet Authorization and Port Knocking"
  homepage "https://www.cipherdyne.org/fwknop/"
  url "https://www.cipherdyne.org/fwknop/download/fwknop-2.6.11.tar.gz"
  mirror "https://github.com/mrash/fwknop/releases/download/2.6.11/fwknop-2.6.11.tar.gz"
  sha256 "bcb4e0e2eb5fcece5083d506da8471f68e33fb6b17d9379c71427a95f9ca1ec8"
  license "GPL-2.0-or-later"
  head "https://github.com/mrash/fwknop.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_sonoma:   "7aad6624e67267a7a4dd7dbe089cd9de6a0ec0420c646a033e7c03c30b70bee2"
    sha256 arm64_ventura:  "15c2272173da7bc217dc32847ed34e9607952f2ee95d69269a79663eb6493e9d"
    sha256 arm64_monterey: "8e8b947582a394a113c5c3fab41dc69c7528276edbf0a732a64c2589d0d09229"
    sha256 sonoma:         "8e5985bc654aaa5f71525c60a74e68037c84ce3a21c5ad5778c62270fb91aa6d"
    sha256 ventura:        "f199526a5fc0eead9499e4e811a7a0429067c04c828dd6cde1476f004224f97a"
    sha256 monterey:       "28d812f4efb74c7749a744a8801b3b1ae12bf25f1941b2b910f19da3ed9b6fa8"
    sha256 x86_64_linux:   "6041c174c567035e621ee9508aa89bd6af671cdfaf7bc99d88eccc473f69f9de"
  end

  depends_on "gpgme"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "iptables"
  end

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --with-gpgme
      --with-gpg=#{Formula["gnupg"].opt_bin}/gpg
    ]
    args << "--with-iptables=#{Formula["iptables"].opt_prefix}" unless OS.mac?
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fwknop --version")
    assert_match(/KEY_BASE64:\s*.+/, shell_output("#{bin}/fwknop --key-gen"))
  end
end
