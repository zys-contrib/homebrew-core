class NestopiaUe < Formula
  desc "NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://github.com/0ldsk00l/nestopia/archive/refs/tags/1.53.1.tar.gz"
  sha256 "21aa45f6c608fe290d73fdec0e6f362538a975455b16a4cc54bcdd10962fff3e"
  license "GPL-2.0-or-later"
  head "https://github.com/0ldsk00l/nestopia.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "a0bdb08096a005edbb35f9807d2b834e9a8f79811c75b473d5584e0bf4efdcdc"
    sha256 arm64_sonoma:  "68e0b4795fc64dbf8158146a5f7fd96a99bb057ce06444c72dd8d1b275f25dc5"
    sha256 arm64_ventura: "8f2025bd929b74f756227cd72beef6fd04c12f0f17aa2f9987b475cc55ee161f"
    sha256 sonoma:        "e92205869fe6d03479e708ecdd00a05ab9799552195ce9aff49e25668c328418"
    sha256 ventura:       "f885dc6e40568171755c0b7b12b808b1fe051ecc12682dbd5fa8d9e7c7ab9aa2"
    sha256 x86_64_linux:  "cdede8ff541df4b2f4d553e7d99043ac1a35e4e403e9286cc6bb80cb22dd1fb8"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "fltk"
  depends_on "libarchive"
  depends_on "libepoxy"
  depends_on "libsamplerate"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--datarootdir=#{pkgshare}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Nestopia UE #{version}", shell_output("#{bin}/nestopia --version")
  end
end
