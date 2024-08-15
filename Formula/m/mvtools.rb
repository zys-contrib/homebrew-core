class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/refs/tags/v24.tar.gz"
  sha256 "ccff47f4ea25aa13b13fabd5cf38dd0be1ceda10d9ad6b52bd42ecf9d6eb24ad"
  license "GPL-2.0-or-later"
  head "https://github.com/dubhater/vapoursynth-mvtools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ad9a10e892d253852f0cf776b7992259480f21be24986c7680874c9065a77a26"
    sha256 cellar: :any,                 arm64_ventura:  "62463942e374b3ee49958f63a3e5bce607c9b82dc71857f300b95f531b292bb3"
    sha256 cellar: :any,                 arm64_monterey: "3bfb4e19aa3c81d1b1b0b1c0fe00f68a58aece15f10f14858081f505fb417922"
    sha256 cellar: :any,                 arm64_big_sur:  "7d4b6d61679ece8fcfb83a9a754e4263c7d94bdb0e2978a574d07af472743995"
    sha256 cellar: :any,                 sonoma:         "c4733b504bd9dccbec20756fd80fce70155043aee6003a858bf9ecbc1e587ee3"
    sha256 cellar: :any,                 ventura:        "2af3b406d3e75883646d39fb31f827c7b1bf7efd63fb517705500233c56e3388"
    sha256 cellar: :any,                 monterey:       "b52650498b19ccf12a79d4334c7e21255fe4e79b987c3259772de047ac679b58"
    sha256 cellar: :any,                 big_sur:        "5bc809a1aadf67ec0a0b962a773b87c9c314780e919b2c56fd0904e898e08c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb7513fa52143b1835cbd909417dc89e4dd52da381ecc0dd33e27699779e173f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build

  depends_on "fftw"
  depends_on "vapoursynth"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  def caveats
    <<~EOS
      MVTools will not be autoloaded in your VapourSynth scripts. To use it
      use the following code in your scripts:

        vs.core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/#{shared_library("libmvtools")}")
    EOS
  end

  test do
    script = <<~EOS.split("\n").join(";")
      import vapoursynth as vs
      vs.core.std.LoadPlugin(path="#{lib/shared_library("libmvtools")}")
    EOS
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", script
  end
end
