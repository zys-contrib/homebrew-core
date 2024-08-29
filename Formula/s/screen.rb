class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen/"
  url "https://ftp.gnu.org/gnu/screen/screen-5.0.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/screen/screen-5.0.0.tar.gz"
  sha256 "f04a39d00a0e5c7c86a55338808903082ad5df4d73df1a2fd3425976aed94971"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/screen.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "7eb9de9e4d0e2afb4c4ae8f243a680195a407ff90b52a621bc6381b949175890"
    sha256 arm64_ventura:  "04ad8f56bd2779a33507db4dc0c4d2bde8adf55c55f498a73b958a6d284480a4"
    sha256 arm64_monterey: "95c6ca795cac6af997554d8516cd1ff33bd4bd60987a988e298c33671743a422"
    sha256 arm64_big_sur:  "d16af53c7667ddb58d38ec09bcd410824d05df09d18a30e368856df2e0970a6f"
    sha256 sonoma:         "9cfcc7667c004261be837a37d3a3cbe8ea445e114a323f5498f1abc7ae016b9e"
    sha256 ventura:        "946970f422fa285f5a3154612630444e98a6a7bcc7579caf174b13456b16664c"
    sha256 monterey:       "8fa812527fbbe1786423f29310caa993858b7bd5b95922aca7713078135397b4"
    sha256 big_sur:        "7d5f4d3be91c4aec072defd3fb083fd38dc56e9ba111e7acaab15e71ae073ad9"
    sha256 x86_64_linux:   "576d96f72e6e6a6b533adb65a016cf068bf97937baff72fbf7b4beec1f5e3c3d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    args = %W[
      --mandir=#{man}
      --infodir=#{info}
      --enable-pam
    ]

    system "./autogen.sh"

    # Exclude unrecognized options
    std_args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }
    system "./configure", *args, *std_args
    system "make", "install"
  end

  test do
    system bin/"screen", "-h"
  end
end
