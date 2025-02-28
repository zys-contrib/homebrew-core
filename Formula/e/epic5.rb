class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "https://www.epicsol.org/"
  url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-3.0.3.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-3.0.3.tar.xz"
  sha256 "63a411215c14040b65b5d728aff10f7523d55e170f6298fb01e1cf958d79d326"
  license "BSD-3-Clause"
  head "https://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "515973a8069ef40d53a5be224c41a979946a2e5a13def51bae803f7438c8e7a2"
    sha256 arm64_sonoma:  "7fee312ffc37972ef16942649a6158470a546f22ded2143845fe85d44a23a5c0"
    sha256 arm64_ventura: "fc4e50f6eb1d18b65fb6cd8eb75049199e09ec3ec78b2ddba154b2de3efcb7b6"
    sha256 sonoma:        "fa5f02d64387fcf1854c0d704db5a3914a7cae34a1849b4d768baccd2db829db"
    sha256 ventura:       "8d898e59813c05eb5a0ef344205179b97390ef8560f3e37130602aa09b2b09c6"
    sha256 x86_64_linux:  "f4d857f0202584ce941de72d6176a9dd91ce86e11872357b5d0643b151187517"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    connection = fork do
      exec bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end
