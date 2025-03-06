class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/2.0/gnome-recipes-2.0.4.tar.xz"
  sha256 "b30e96985f66fe138a17189c77af44d34d0b4c859b304ebdb52033bc2cd3ffed"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 arm64_sequoia: "aeca025b7378f47ce41dc347deb424d0944de6e7da3408c6e775570ec25a321c"
    sha256 arm64_sonoma:  "b65f11b25c9f58fa146f4a60b1c8ac1f1f807ffb48c91234b73736ae9d8d3ad6"
    sha256 arm64_ventura: "839f681efb2bc6d86d2c399a1bb4236f852a177f0c1899b65580a5ef55511acb"
    sha256 sonoma:        "056abd76e963efbe48a5459b8a0a6c7d97b51efaacdd4ae7ec401c1c433e1f58"
    sha256 ventura:       "cbb8cda97c299ad0c43bc5536923992ce0aee73ce2757956c17d477e588de34c"
    sha256 x86_64_linux:  "0cbf9ab64b5ab37f4ea338f445b5f53d50ee6cd5cf91d66da1bdd348a3982775"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnome-autoar"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "json-glib" # for goa
  depends_on "libcanberra"
  depends_on "librest" # for goa
  depends_on "libsoup"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  resource "goa" do
    url "https://download.gnome.org/sources/gnome-online-accounts/3.52/gnome-online-accounts-3.52.3.1.tar.xz"
    sha256 "49ed727d6fc49474996fa7edf0919b21e4fc856ea37e6e30f17b50b103af9701"
  end

  # Apply Debian patch to support newer libsoup and librest
  # PR ref: https://gitlab.gnome.org/GNOME/recipes/-/merge_requests/47
  patch do
    url "https://sources.debian.org/data/main/g/gnome-recipes/2.0.4-3/debian/patches/Port-to-libsoup-3.0-and-librest-1.0.patch"
    sha256 "15a06b277d3961d4a00e71eb37b12f4f63f42c99bc1c1a6c9d9f4ead879d4c32"
  end

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    resource("goa").stage do
      system "meson", "setup", "build", "-Dgoabackend=false",
                                        "-Ddocumentation=false",
                                        "-Dintrospection=false",
                                        "-Dman=false",
                                        "-Dvapi=false",
                                        *std_meson_args.map { |s| s.sub prefix, libexec }
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    # Add RPATH to libexec in goa-1.0.pc on Linux.
    unless OS.mac?
      inreplace libexec/"lib/pkgconfig/goa-1.0.pc", "-L${libdir}",
                "-Wl,-rpath,${libdir} -L${libdir}"
    end

    # BSD tar does not support the required options
    inreplace "src/gr-recipe-store.c", "argv[0] = \"tar\";", "argv[0] = \"gtar\";" if OS.mac?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"gnome-recipes", "--help"
  end
end
