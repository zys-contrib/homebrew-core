class Libgnt < Formula
  desc "NCurses toolkit for creating text-mode graphical user interfaces"
  homepage "https://keep.imfreedom.org/libgnt/libgnt"
  url "https://downloads.sourceforge.net/project/pidgin/libgnt/2.14.3/libgnt-2.14.3.tar.xz"
  sha256 "57f5457f72999d0bb1a139a37f2746ec1b5a02c094f2710a339d8bcea4236123"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://sourceforge.net/projects/pidgin/rss?path=/libgnt"
    regex(%r{url=.*?/libgnt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a66452550322ba230ac6702de7e9191a65635c6e043d9aa0feb77e12efc8eef0"
    sha256 cellar: :any, arm64_ventura:  "a9de916fc69770d8bbc6ad92c36950a3d3810d745cb4a8c9b55d7c4cff4a03cd"
    sha256 cellar: :any, arm64_monterey: "5b9638fd113cb8a914c26d16d50865c313c5ce57d57e7afa5e857f6ef576d9c7"
    sha256 cellar: :any, arm64_big_sur:  "a4c4c927df6b0fb2dd4bc6dbf742085eb171c146a448f218448f53e1a21d5015"
    sha256 cellar: :any, sonoma:         "353a2a0f4f9cec6688edf17bd965e41e8b08963376e6b537131c1317e9e9fb32"
    sha256 cellar: :any, ventura:        "62c52f2e13689bf9b1d7dbb7d9323df4334518425276f8cf5858ea6fc00e0fa2"
    sha256 cellar: :any, monterey:       "dcc301110a688e48df0946e77ad07b7112c6bd88fc459b6ae9c6d752b0883c87"
    sha256 cellar: :any, big_sur:        "97d22f2f66bfc361cc88dd7ef38a912c11db9bf77346f20645bec433a3444f38"
    sha256 cellar: :any, catalina:       "ac0543b64dfccaed26f40fd585b9546dede02550afa4063fb76b8f970a2379d8"
    sha256 cellar: :any, mojave:         "b558ad3400f33a9559ace90c2d53e7e578ca674cbae105b2ec620ab277da21cf"
    sha256               x86_64_linux:   "ebff16ba92fadae787c491dae1094706039b2c73a44a1fcacbc2371b031ee647"
  end

  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "ncurses"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  # build patch for ncurses 6
  patch :DATA

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    # upstream bug report on this workaround, https://issues.imfreedom.org/issue/LIBGNT-15
    inreplace "meson.build", "ncurses_sys_prefix = '/usr'",
                             "ncurses_sys_prefix = '#{Formula["ncurses"].opt_prefix}'"

    system "meson", "setup", "build", "-Dpython2=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gnt/gnt.h>

      int main() {
          gnt_init();
          gnt_quit();

          return 0;
      }
    EOS

    flags = [
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
      "-I#{include}",
      "-L#{lib}",
      "-L#{Formula["glib"].opt_lib}",
      "-lgnt",
      "-lglib-2.0",
    ]
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/gntwm.c b/gntwm.c
index ffb1f4a..2ca4a6a 100644
--- a/gntwm.c
+++ b/gntwm.c
@@ -161,47 +161,49 @@ static void
 work_around_for_ncurses_bug(void)
 {
 #ifndef NO_WIDECHAR
-	PANEL *panel = NULL;
-	while ((panel = panel_below(panel)) != NULL) {
-		int sx, ex, sy, ey, w, y;
-		cchar_t ch;
-		PANEL *below = panel;
-
-		sx = getbegx(panel->win);
-		ex = getmaxx(panel->win) + sx;
-		sy = getbegy(panel->win);
-		ey = getmaxy(panel->win) + sy;
-
-		while ((below = panel_below(below)) != NULL) {
-			if (sy > getbegy(below->win) + getmaxy(below->win) ||
-					ey < getbegy(below->win))
-				continue;
-			if (sx > getbegx(below->win) + getmaxx(below->win) ||
-					ex < getbegx(below->win))
-				continue;
-			for (y = MAX(sy, getbegy(below->win)); y <= MIN(ey, getbegy(below->win) + getmaxy(below->win)); y++) {
-				if (mvwin_wch(below->win, y - getbegy(below->win), sx - 1 - getbegx(below->win), &ch) != OK)
-					goto right;
-				w = widestringwidth(ch.chars);
-				if (w > 1 && (ch.attr & 1)) {
-					ch.chars[0] = ' ';
-					ch.attr &= ~ A_CHARTEXT;
-					mvwadd_wch(below->win, y - getbegy(below->win), sx - 1 - getbegx(below->win), &ch);
-					touchline(below->win, y - getbegy(below->win), 1);
-				}
+    PANEL *panel = NULL;
+    while ((panel = panel_below(panel)) != NULL) {
+        int sx, ex, sy, ey, w, y;
+        cchar_t ch;
+        PANEL *below = panel;
+        WINDOW *panel_win = panel_window(panel);
+
+        sx = getbegx(panel_win);
+        ex = getmaxx(panel_win) + sx;
+        sy = getbegy(panel_win);
+        ey = getmaxy(panel_win) + sy;
+
+        while ((below = panel_below(below)) != NULL) {
+            WINDOW *below_win = panel_window(below);
+            if (sy > getbegy(below_win) + getmaxy(below_win) ||
+                    ey < getbegy(below_win))
+                continue;
+            if (sx > getbegx(below_win) + getmaxx(below_win) ||
+                    ex < getbegx(below_win))
+                continue;
+            for (y = MAX(sy, getbegy(below_win)); y <= MIN(ey, getbegy(below_win) + getmaxy(below_win)); y++) {
+                if (mvwin_wch(below_win, y - getbegy(below_win), sx - 1 - getbegx(below_win), &ch) != OK)
+                    goto right;
+                w = widestringwidth(ch.chars);
+                if (w > 1 && (ch.attr & 1)) {
+                    ch.chars[0] = ' ';
+                    ch.attr &= ~ A_CHARTEXT;
+                    mvwadd_wch(below_win, y - getbegy(below_win), sx - 1 - getbegx(below_win), &ch);
+                    touchline(below_win, y - getbegy(below_win), 1);
+                }
 right:
-				if (mvwin_wch(below->win, y - getbegy(below->win), ex + 1 - getbegx(below->win), &ch) != OK)
-					continue;
-				w = widestringwidth(ch.chars);
-				if (w > 1 && !(ch.attr & 1)) {
-					ch.chars[0] = ' ';
-					ch.attr &= ~ A_CHARTEXT;
-					mvwadd_wch(below->win, y - getbegy(below->win), ex + 1 - getbegx(below->win), &ch);
-					touchline(below->win, y - getbegy(below->win), 1);
-				}
-			}
-		}
-	}
+                if (mvwin_wch(below_win, y - getbegy(below_win), ex + 1 - getbegx(below_win), &ch) != OK)
+                    continue;
+                w = widestringwidth(ch.chars);
+                if (w > 1 && !(ch.attr & 1)) {
+                    ch.chars[0] = ' ';
+                    ch.attr &= ~ A_CHARTEXT;
+                    mvwadd_wch(below_win, y - getbegy(below_win), ex + 1 - getbegx(below_win), &ch);
+                    touchline(below_win, y - getbegy(below_win), 1);
+                }
+            }
+        }
+    }
 #endif
 }

@@ -2287,5 +2289,3 @@ void gnt_wm_set_event_stack(GntWM *wm, gboolean set)
 {
 	wm->event_stack = set;
 }
-
-
