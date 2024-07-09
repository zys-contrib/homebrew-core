class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.8.1.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.8.1.tar.gz"
  sha256 "60c35feafe341aec8fed9de4b0a875dc0f5c1674c5f5804ff7190a6c6c53dc01"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/h/homebank/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a455ffc6c89184905ef95e86ad64f47c116d180c84403a76f3d3500c718e471e"
    sha256 arm64_ventura:  "a87b644ca8699ef4066056c4dd69249fd683b5640d8a5ba9845a520634fcd8e8"
    sha256 arm64_monterey: "bf68a6601ec1121d9819b36287ce21a14d60a4707989a1d57b9f85c6bde2c4ce"
    sha256 sonoma:         "86d67b8c23582998b26e6e2650e8f5ef126411786eb7166d784d94569702c8b3"
    sha256 ventura:        "c8ddf2d9b781aa06334e444a694f4b497cd12ebdc8a85b5e75c1b6c998c66939"
    sha256 monterey:       "43ecddb5048909cf26d9c51b8b1383d54bede58fbe582ef5ae0c548c1e1505dd"
    sha256 x86_64_linux:   "00ea39896f9ff78d82d92f7019aea04faa8a2d0575e66e76f711fd95831da772"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"

  uses_from_macos "perl"

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  # Fix scope of 'name' variable in rep-budget.c
  # upstream bug report, https://bugs.launchpad.net/homebank/+bug/2067543
  # nixpkg patch commit, https://github.com/NixOS/nixpkgs/commit/5b15ea1e00e33223d52c3aabb821de402265b326
  patch :DATA

  def install
    if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ofx"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    # homebank is a GUI application
    system bin/"homebank", "--help"
  end
end

__END__
diff --git a/src/rep-budget.c b/src/rep-budget.c
index eb5cce6..61e2e77 100644
--- a/src/rep-budget.c
+++ b/src/rep-budget.c
@@ -255,7 +255,7 @@ gint tmpmode;
 	}
 	else
 	{
-libname:
+libname: ;
 	gchar *name;

 		gtk_tree_model_get(model, iter,
