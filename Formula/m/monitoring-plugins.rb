class MonitoringPlugins < Formula
  desc "Plugins for nagios compatible monitoring systems"
  homepage "https://www.monitoring-plugins.org"
  url "https://www.monitoring-plugins.org/download/monitoring-plugins-2.4.0.tar.gz"
  sha256 "e5dfd4ad8fde0a40da50aab3aff6d9a27020b8f283e332bc4da6ef9914f4028c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.monitoring-plugins.org/download.html"
    regex(/href=.*?monitoring-plugins[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "8964ad146aab38fc46b9d3794d94607b038e578f807b12df7335cbe747fea689"
    sha256 arm64_ventura:  "42ace3f93ed42a299e9e055c44f85c62ccdfe120bef31f1ee272c731f5ef8bb0"
    sha256 arm64_monterey: "38c990c7c13cc49e958997972fb95207aaf35b0071aefd0a1e02d2a007915a14"
    sha256 sonoma:         "fda974f1768ad4544c67476ddd08a8107131474a51d860f99cdd8982a1f28b83"
    sha256 ventura:        "8713781f32bed97eccc5f12040b264f942f3709298bb0bef4abcfad9603e2b74"
    sha256 monterey:       "b07aa720eb6a8dd39fc0f865cae3403e0a51e0cc559d382fa1a30dd195c50635"
    sha256 x86_64_linux:   "ab67fd985f70e7756cace887a597f7ea4391a019cf0e29ef2ade27fcd1eecc85"
  end

  depends_on "openssl@3"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "bind"
  end

  conflicts_with "nagios-plugins", because: "both install their plugins to the same folder"

  def install
    # workaround for Xcode 14.3
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args = %W[
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  def caveats
    <<~EOS
      All plugins have been installed in:
        #{HOMEBREW_PREFIX}/sbin
    EOS
  end

  test do
    output = shell_output("#{sbin}/check_dns -H brew.sh -s 8.8.8.8 -t 3")
    assert_match "DNS OK", output
  end
end
