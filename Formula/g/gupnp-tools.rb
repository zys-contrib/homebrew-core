class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.12/gupnp-tools-0.12.2.tar.xz"
  sha256 "4c92f2d1a3d454ec1f5fb05ef08ca34df9c743af64c8b5965c35884d46cb005c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "0250ac0349cfb699686b66f5e51ab129e081f96dd40202d79d56ad33d3741bc7"
    sha256 arm64_sonoma:   "e33bfb2942a1ca1efc68fe987d8a8be8c19c69c5b17f0a4b8d59d7ccd8b8b777"
    sha256 arm64_ventura:  "7e53eb43413d211922c3b631f04263d4856b30041a8fc7ffb8c427397b96fe5f"
    sha256 arm64_monterey: "c4909d493392f97185eb1f155ef2c22a084092066052acc33465c462de0542d6"
    sha256 sonoma:         "f308ed29fd55ed3fffba76505cc9247b0651773b32708b9fe8464ee76b96d8f9"
    sha256 ventura:        "824675ba1db8c43795fcbfa08dd1b6e1f8b66bdfcb2fe8c93772c661b05cf050"
    sha256 monterey:       "e347b8ea0441314d43cb0d0dc483d838dbbdd2616da0dadb50a0170e1e9bf149"
    sha256 x86_64_linux:   "cb048c2652775c18c131c4298ade3bd54521434e980d9956a0c23277c0106ff9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gssdp"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "libsoup"
  depends_on "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gupnp-universal-cp", "-h"
    system bin/"gupnp-av-cp", "-h"
  end
end
