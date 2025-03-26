class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  license "MPL-2.0"

  stable do
    # NOTE: the livecheck block is a best guess at excluding development versions.
    #       Check https://www.isc.org/download/#Kea to make sure we're using a stable version.
    url "https://ftp.isc.org/isc/kea/2.6.2/kea-2.6.2.tar.gz"
    mirror "https://dl.cloudsmith.io/public/isc/kea-2-6/raw/versions/2.6.2/kea-2.6.2.tar.gz"
    sha256 "8a50b63103734b59c3b8619ccd6766d2dfee3f02e3a5f9f3abc1cd55f70fa424"

    # Backport support for Boost 1.87.0
    patch do
      url "https://gitlab.isc.org/isc-projects/kea/-/commit/81edc181f85395c39964104ef049a195bafb9737.diff"
      sha256 "17fd38148482e61be2192b19f7d05628492397d3f7c54e9097a89aeacf030072"
    end
  end

  livecheck do
    url "ftp://ftp.isc.org/isc/kea/"
    # Match the final component lazily to avoid matching versions like `1.9.10` as `9.10`.
    regex(/v?(\d+\.\d*[02468](?:\.\d+)+?)$/i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_sequoia: "ea6fb38b3daee77b1049f0833bb2acffc9546b19aa5d8fb0c096fff2bdc209e9"
    sha256 arm64_sonoma:  "0d09a65ad289a9209feca86df4cdbb62144e7583bec1897099401d9a1cd3619a"
    sha256 arm64_ventura: "d14266bef57406a13dc79defec164b5e1f21e4315539f234593b8c2495d44600"
    sha256 sonoma:        "3cae18d12ace2e3c9d22bf1e5e7b0abc2c5051d6aa083d629850cf0548ee73d0"
    sha256 ventura:       "0de8f2810f380300a418cb9dbd17c4b74916532cb698b37bd82b10947e81ff2f"
    sha256 x86_64_linux:  "662a312f7d4a72ab9c7f000a21dd21f37b6136ec1b0931786b6a5dcf197a2b70"
  end

  head do
    url "https://gitlab.isc.org/isc-projects/kea.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "log4cplus"
  depends_on "openssl@3"

  def install
    # Workaround to build with Boost 1.87.0+
    ENV.append "CXXFLAGS", "-std=gnu++14"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"keactrl", "status"
  end
end
