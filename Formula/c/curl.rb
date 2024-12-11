class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  # `url` goes below this comment when the `stable` block is removed.
  url "https://curl.se/download/curl-8.11.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_11_1/curl-8.11.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.11.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.11.1.tar.bz2"
  sha256 "e9773ad1dfa21aedbfe8e1ef24c9478fa780b1b3d4f763c98dd04629b5e43485"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "fa00dd72ba2ae659dd1df16944fd500e8b7a661cf6bad08333057f2aa4f04ac0"
    sha256 cellar: :any,                 arm64_sonoma:  "c72dd1cedeac49b1017aced05874cbc659876f2188b0e2e1a971c4bad3ca655f"
    sha256 cellar: :any,                 arm64_ventura: "f1aca9b7d22a8b1efa4e6f1f123bd65163bfaf93f9d9e3cd9633754be4e5dea2"
    sha256 cellar: :any,                 sonoma:        "260961cdb1ae53fb8fc139f795521e47ffa2657d91e4ed39e522aff441a66808"
    sha256 cellar: :any,                 ventura:       "180e8327f2b6a3442dd1596b81341e8bee042904e3b6027e50d48cb35af8c35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d05dbe3184bcfcaeb057b67cdb4c53cb4cbf727964ae5df3ba421740e3c28d56"
  end

  head do
    url "https://github.com/curl/curl.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => [:build, :test]
  depends_on "brotli"
  depends_on "libnghttp2"
  depends_on "libssh2"
  depends_on "openssl@3"
  depends_on "rtmpdump"
  depends_on "zstd"

  uses_from_macos "krb5"
  uses_from_macos "openldap"
  uses_from_macos "zlib"

  on_system :linux, macos: :monterey_or_older do
    depends_on "libidn2"
  end

  def install
    tag_name = "curl-#{version.to_s.tr(".", "_")}"
    if build.stable? && stable.mirrors.grep(/github\.com/).first.exclude?(tag_name)
      odie "Tag name #{tag_name} is not found in the GitHub mirror URL! " \
           "Please make sure the URL is correct."
    end

    system "./buildconf" if build.head?

    args = %W[
      --disable-silent-rules
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --without-ca-bundle
      --without-ca-path
      --with-ca-fallback
      --with-secure-transport
      --with-default-ssl-backend=openssl
      --with-librtmp
      --with-libssh2
      --without-libpsl
      --with-zsh-functions-dir=#{zsh_completion}
      --with-fish-functions-dir=#{fish_completion}
    ]

    args << if OS.mac?
      "--with-gssapi"
    else
      "--with-gssapi=#{Formula["krb5"].opt_prefix}"
    end

    args += if OS.mac? && MacOS.version >= :ventura
      %w[
        --with-apple-idn
        --without-libidn2
      ]
    else
      %w[
        --without-apple-idn
        --with-libidn2
      ]
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "scripts/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = testpath/"test.tar.gz"
    system bin/"curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    # Check dependencies linked correctly
    curl_features = shell_output("#{bin}/curl-config --features").split("\n")
    %w[brotli GSS-API HTTP2 IDN libz SSL zstd].each do |feature|
      assert_includes curl_features, feature
    end
    curl_protocols = shell_output("#{bin}/curl-config --protocols").split("\n")
    %w[LDAPS RTMP SCP SFTP].each do |protocol|
      assert_includes curl_protocols, protocol
    end

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_path_exists testpath/"test.pem"
    assert_path_exists testpath/"certdata.txt"

    with_env(PKG_CONFIG_PATH: lib/"pkgconfig") do
      system "pkgconf", "--cflags", "libcurl"
    end
  end
end
