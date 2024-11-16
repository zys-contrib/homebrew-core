class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "https://dict.org/bin/Dict"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.13.3/dictd-1.13.3.tar.gz"
  sha256 "192129dfb38fa723f48a9586c79c5198fc4904fec1757176917314dd073f1171"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "9d1700a2f65af4c81450991adb6774bcb3ab2402dd415570e0fac4930656e7d0"
    sha256 arm64_sonoma:  "c51f1b3870033601c58b2e9da5b22a266be61bc6949eff04e002442a38047aca"
    sha256 arm64_ventura: "1f6afea25d3c716196b6b133ebbab87f3cb2ee5d8d41c72629e89e74c6394ffc"
    sha256 sonoma:        "cebb05ffbe29fb85618138b7d388ba34554290ae81be83e5511eb767ecc0ea8f"
    sha256 ventura:       "ec59898ae0e21bc460eef7f56c95bcb6a151df6e9ee16d510e26365440bb5552"
    sha256 x86_64_linux:  "04d9534b5e3359bbb4497b7093e6575f629c78be6f0efc095df43037a392b29c"
  end

  depends_on "libtool" => :build
  depends_on "libmaa"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    # Workaround for Xcode 14.3
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["ac_cv_search_yywrap"] = "yes"
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
    (prefix+"etc/dict.conf").write <<~EOS
      server localhost
      server dict.org
    EOS
  end

  test do
    assert_match "brewing or making beer.", shell_output("#{bin}/dict brew")
  end
end
