class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.7.tar.bz2"
  sha256 "7b24706e4da7e0e3b06ca068231027401f238102c41c909631349dcc3b85eb46"
  license "GPL-3.0-or-later"

  # GnuPG appears to indicate stable releases with an even-numbered minor
  # (https://gnupg.org/download/#end-of-life).
  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "1158518050462f44e5ce0f85bdff8c1b6d773b5a8e4e2d23c71c3b3b46e9505c"
    sha256 arm64_sonoma:  "4d4e17420b3e2c4ce95358f51991099f66bfcba197b5f9ac75b2bb15c25c0fc2"
    sha256 arm64_ventura: "702b2cb99bae04925d020ed886aab095190b486b5caa418af85a1a30c7169212"
    sha256 sonoma:        "f35b61defdaa19b0cb577bb0e8129a69d508afc3b3932fb449fa9082b8fff576"
    sha256 ventura:       "19d12de3d1baf0ea5d5978c85cd8fce2d735ecd7432dfb7bd1214dadc82e370f"
    sha256 x86_64_linux:  "7eecb260956f7ff5bd31488ec423caabf1fdf88d8280ae9c9cf4b7b6f7b1ee64"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "pinentry"
  depends_on "readline"

  uses_from_macos "bzip2"
  uses_from_macos "openldap"
  uses_from_macos "sqlite", since: :catalina
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    libusb = Formula["libusb"]
    ENV.append "CPPFLAGS", "-I#{libusb.opt_include}/libusb-#{libusb.version.major_minor}"

    mkdir "build" do
      system "../configure", "--disable-silent-rules",
                             "--enable-all-tests",
                             "--sysconfdir=#{etc}",
                             "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry",
                             "--with-readline=#{Formula["readline"].opt_prefix}",
                             *std_configure_args
      system "make"
      system "make", "check"
      system "make", "install"
    end

    # Configure scdaemon as recommended by upstream developers
    # https://dev.gnupg.org/T5415#145864
    if OS.mac?
      # write to buildpath then install to ensure existing files are not clobbered
      (buildpath/"scdaemon.conf").write <<~CONF
        disable-ccid
      CONF
      pkgetc.install "scdaemon.conf"
    end
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  test do
    (testpath/"batch.gpg").write <<~GPG
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    GPG

    begin
      system bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      (testpath/"test.txt").write "Hello World!"
      system bin/"gpg", "--detach-sign", "test.txt"
      system bin/"gpg", "--verify", "test.txt.sig"
    ensure
      system bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
