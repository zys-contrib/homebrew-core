class Abook < Formula
  desc "Address book with mutt support"
  homepage "https://abook.sourceforge.io/"
  license all_of: [
    "GPL-3.0-only",
    "GPL-2.0-or-later",  # mbswidth.c
    "LGPL-2.0-or-later", # getopt.c
    "BSD-2-Clause",      # xmalloc.c
    "BSD-4.3RENO",       # ldif.c
  ]
  head "https://git.code.sf.net/p/abook/git.git", branch: "master"

  stable do
    url "https://git.code.sf.net/p/abook/git.git",
        tag:      "ver_0_6_2",
        revision: "a243d4a18a64f4ee188191a797b34f60d4ff852f"

    # Backport include from https://sourceforge.net/p/abook/git/ci/39484721c44629fb1f54d92f09c92ef4c3201302/
    patch :DATA
  end

  bottle do
    sha256 arm64_sequoia:  "aecfb31d48ba2a09945e883238d39f657fb3999b2f5419514445686aca65cf11"
    sha256 arm64_sonoma:   "c0b9ae72d7b4b319def0cc4f65051a392a3cd9318d607d736b6d80eb5eee3210"
    sha256 arm64_ventura:  "dbcc8ffc1eb5ee674721acec2fc715030ba3c53553f0b419c71994f72925e298"
    sha256 arm64_monterey: "24854522e2901befeb323be066c744ab4471920495b7a91280e9d05c9bc3b9e7"
    sha256 arm64_big_sur:  "e062925ce6b559649d5574f2ee4a709611df4a9a54f3396cf706c2a399cc747f"
    sha256 sonoma:         "ee3e21157d0d6a21e8070e89e102ebeef8b4d7a4a8e72b3440d8638141a35bf5"
    sha256 ventura:        "82da61749b4896e7e09c2655a372f49a371d660f089c494ca49091a05a2f1993"
    sha256 monterey:       "923df44c0bbcdcb70df775092fb6aacb3c7c4740a12d40ce6f5ad4a8dd7ea91f"
    sha256 big_sur:        "0c4b7d1c41dbd920e192711e8ed1200db46c30be141aaaeb606c41718d0c2a79"
    sha256 catalina:       "09e77aa3db2cf8a702effbebbbf83f7a2f860b0d5db6bcf37549edb7db5438a7"
    sha256 mojave:         "a6ab99c751a03e11e2ace660ad9325a9fe4262598f284c0fb87626778383e29d"
    sha256 high_sierra:    "a0461ecc678e5cb65a901bd39dbd7f0f8015a29ed605e6cf28f1315d5c347ecb"
    sha256 x86_64_linux:   "32ec309e47f9cc195c0bc8c9bccdf1169ff91e211991eeb1fb04d91872c3be51"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"abook", "--formats"
  end
end

__END__
diff --git a/database.c b/database.c
index 384223e..eb9b4b0 100644
--- a/database.c
+++ b/database.c
@@ -12,6 +12,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <assert.h>
+#include <ctype.h>
 #ifdef HAVE_CONFIG_H
 #      include "config.h"
 #endif
