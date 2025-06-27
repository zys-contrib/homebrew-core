class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  url "https://ftp.isc.org/isc/kea/3.0.0/kea-3.0.0.tar.xz"
  mirror "https://dl.cloudsmith.io/public/isc/kea-3-0/raw/versions/3.0.0/kea-3.0.0.tar.xz"
  sha256 "bf963d1e10951d8c570c6042afccf27c709d45e03813bd2639d7bb1cfc4fee76"
  license "MPL-2.0"
  head "https://gitlab.isc.org/isc-projects/kea.git", branch: "master"

  # NOTE: the livecheck block is a best guess at excluding development versions.
  #       Check https://www.isc.org/download/#Kea to make sure we're using a stable version.

  livecheck do
    url "ftp://ftp.isc.org/isc/kea/"
    # Match the final component lazily to avoid matching versions like `1.9.10` as `9.10`.
    regex(/v?(\d+\.\d*[02468](?:\.\d+)+?)$/i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_sequoia: "4c66f8f52593d9e945699305f4fe64388472f6de31a061733c5a87370fb6479c"
    sha256 arm64_sonoma:  "f8053d8a6fcd8b24e825049ec6debc1122c66e476e87bc969a526d7322aeeb79"
    sha256 arm64_ventura: "d1371ae2cc23ff1ec5af366b12d241b67d019caa9310728c570c3f7d8d84d153"
    sha256 sonoma:        "b977974fce305b9e45b45c3cf9f3686d21a0ab4cc37ec90405c65894af2b70ce"
    sha256 ventura:       "9cf0169cc4bb7ba9ecef631cca6c083014fda86a7a064d9919245840c6be6ea2"
    sha256 arm64_linux:   "fe9d2c5f9a9c911c0191ecc7c9e24c3b756e4665d65b7dc19224e3458f9374c7"
    sha256 x86_64_linux:  "c9d151d10c0ebd376294c91e4f5b353217d3226d9c711633cfcd23198b8d603b"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "boost"
  depends_on "log4cplus"
  depends_on "openssl@3"

  def install
    # the build system looks for `sudo` to run some commands, but we don't want to use it
    inreplace "meson.build",
              "SUDO = find_program('sudo', required: false)",
              "SUDO = find_program('', required: false)"

    system "meson", "setup", "build", "-Dcpp_std=c++20", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Remove the meson-info directory as it contains shim references
    rm_r(pkgshare/"meson-info")
  end

  test do
    system sbin/"keactrl", "status"
  end
end
