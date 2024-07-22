class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.24.0.tar.gz"
  sha256 "5bda099d7db16dc33fee137ca8768dd9544e3c345e803289c3576bb8e2c99391"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]

  livecheck do
    url "https://cfengine-package-repos.s3.amazonaws.com/release-data/community/releases.json"
    regex(/["']version["']:\s*["'](\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 arm64_sonoma:   "28b96d1f0f2daf07422bc23ec9538b1c61f56847d49cbeb86cf36721cdc943db"
    sha256 arm64_ventura:  "1570f76deae4f2d02ee25fe7226cfe0eeec7849b656d0217ac994f4938fd76c5"
    sha256 arm64_monterey: "c7ff210a0fa52481fb287eb8d2c5e9ce3966f211a9b8ebd75d4bbe11eed5e37b"
    sha256 sonoma:         "88cbe41b16a6fbb7dea06a0f866b87d67f8adf6a4b1bf06f33c360523065c32a"
    sha256 ventura:        "d6be87f933d40caeff5132f15b50291a5883d693dc1454925d59be2f471b7e00"
    sha256 monterey:       "24ba49dd05ecf2c8136dfd6f11ed77bc907841cff05181a2262def819cf97e32"
    sha256 x86_64_linux:   "cf4f1070ffbc86d5273b80788370a82503788227a82a67c7822f3fec364eec36"
  end

  depends_on "lmdb"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "curl", since: :ventura # uses CURLOPT_PROTOCOLS_STR, available since curl 7.85.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "linux-pam"
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.24.0.tar.gz"
    sha256 "0611c3137cc3142d46b45055ea4473b1c115593d013ebe02121bd7304bc7ab79"
  end

  def install
    odie "masterfiles resource needs to be updated" if version != resource("masterfiles").version

    args = %W[
      --with-workdir=#{var}/cfengine
      --with-lmdb=#{Formula["lmdb"].opt_prefix}
      --with-pcre2=#{Formula["pcre2"].opt_prefix}
      --without-mysql
      --without-postgresql
    ]

    args << "--with-systemd-service=no" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  def post_install
    workdir = var/"cfengine"
    secure_dirs = %W[
      #{workdir}/inputs
      #{workdir}/outputs
      #{workdir}/ppkeys
      #{workdir}/plugins
    ]
    chmod 0700, secure_dirs
    chmod 0750, workdir/"state"
    chmod 0755, workdir/"modules"
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
