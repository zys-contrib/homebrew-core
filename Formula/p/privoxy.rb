class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/4.0.0%20%28stable%29/privoxy-4.0.0-stable-src.tar.gz"
  sha256 "c08e2ba0049307017bf9d8a63dd2a0dfb96aa0cdeb34ae007776e63eba62a26f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/privoxy[._-]v?(\d+(?:\.\d+)+)[._-]stable[._-]src\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "97f2f5971c167ff964445e8294e6b577ecfab9edc660133281ddc77f066ccc77"
    sha256 cellar: :any,                 arm64_sonoma:  "08aeaed4a5bceb64b7133cd1b9cedc8caa425de38581020e7b2c8554ec0609fd"
    sha256 cellar: :any,                 arm64_ventura: "064cbe795744a5e15d18b2f2fa28b92992fcb2eae53fd6de3546908b0f2f041f"
    sha256 cellar: :any,                 sonoma:        "b209390e2cdaf34c07e1530708abacb1613b08e8c8bec9a237c36200882e4f54"
    sha256 cellar: :any,                 ventura:       "97bb54f2c404b840d1d12e25a1093b767ceacdb2cb829b3ee7178ac755693deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d2377396f93e9ddfb8725a754533e1ce4e9077d15087773f6a9f807b50ae533"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre2"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  service do
    run [opt_sbin/"privoxy", "--no-daemon", etc/"privoxy/config"]
    keep_alive true
    working_dir var
    error_log_path var/"log/privoxy/logfile"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    (testpath/"config").write("listen-address #{bind_address}\n")
    pid = spawn sbin/"privoxy", "--no-daemon", testpath/"config"
    begin
      sleep 5
      output = shell_output("curl --head --proxy #{bind_address} https://github.com")
      assert_match "HTTP/1.1 200 Connection established", output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
