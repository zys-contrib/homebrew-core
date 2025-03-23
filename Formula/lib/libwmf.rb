class Libwmf < Formula
  desc "Library for converting WMF (Window Metafile Format) files"
  homepage "https://github.com/caolanm/libwmf"
  url "https://github.com/caolanm/libwmf/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "18ba69febd2f515d98a2352de284a8051896062ac9728d2ead07bc39ea75a068"
  license all_of: [
    "LGPL-2.0-or-later",
    "GPL-2.0-or-later", # COPYING
    "GD", # src/extra/gd
  ]

  bottle do
    sha256 arm64_sequoia:  "e0cc5c1d1e18f0a0ebf5bd15ece8c8b542c0838756d51a1b6c4ff6374cb8bc32"
    sha256 arm64_sonoma:   "877950d7e281db2ae95cb74cab50330b721416f6389f5f9bdc985bf2e2c5b926"
    sha256 arm64_ventura:  "bd3df915d0b9d87c94aab7ee63670f911c971c7733d7f4a5b711b65e4d6a05b0"
    sha256 arm64_monterey: "3e48bed98b30b6740c80267498806123a035d100711c6ed8afcb5399dabd2d06"
    sha256 arm64_big_sur:  "544befd86f2efc9ba73b08b2724c0e1951d88c8fe753aa568e442df449d55192"
    sha256 sonoma:         "64679a33288e29e92ec766c07e47afc1131eb48d6acb088317557bfaeddc4ac0"
    sha256 ventura:        "c5c923d66e7954cb488c631bc0dc9f1fa52c1fd5b63d50639d78020db10d88f3"
    sha256 monterey:       "f83417389f14343ca059d9c13c91b01cef4b5fa8ecccee254bbbcf830a6c0c2f"
    sha256 big_sur:        "5886a1a89f5a13f4b1d6e3b9bf5d6d9bbc237833e9ff0347679cf17a6b5d40f8"
    sha256 catalina:       "5a79438b49930e82ab4761644daa03d4843041ed4e245b47a208301a4a88d35e"
    sha256 arm64_linux:    "a22a4a32c11fd0f92d5488328c59a4243b56c49524157eed7190ad8a60ab4e40"
    sha256 x86_64_linux:   "a18467741b4b8a3b995017473f8481d46023e36f5af44b28be538aa306007962"
  end

  depends_on "pkgconf" => :build

  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  # Backport fix for macOS
  patch do
    url "https://github.com/caolanm/libwmf/commit/5c0ffc6320c40a565ff8014d772670df3e0ad87d.patch?full_index=1"
    sha256 "80ae84a904baa21e1566e3d2bca1c6aaa0a2a30f684fe50f25e7e5751ef3ec93"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-gsfontdir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts",
                          "--with-gsfontmap=#{HOMEBREW_PREFIX}/share/ghostscript/Resource/Init/Fontmap.GS",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    resource "formula1.wmf" do
      url "https://github.com/caolanm/libwmf/raw/3ea3a65ad1b4528ed1c5795071a0142a0e61ec7b/examples/formula1.wmf"
      sha256 "a0d9829692eebfa3bdb23d62f474d58cc4ea2489c07c6fcb63338eb3fb2c14d2"
    end
    resource("formula1.wmf").stage(testpath)

    output = shell_output("#{bin}/wmf2svg --maxwidth=100 --maxheight=100 formula1.wmf")
    assert_match '<svg width="100" height="18"', output

    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/wmf2svg --version 2>&1", 2)
  end
end
