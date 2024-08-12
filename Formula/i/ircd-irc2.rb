class IrcdIrc2 < Formula
  desc "Original IRC server daemon"
  homepage "http://www.irc.org/"
  url "http://www.irc.org/ftp/irc/server/irc2.11.2p3.tgz"
  version "2.11.2p3"
  sha256 "be94051845f9be7da0e558699c4af7963af7e647745d339351985a697eca2c81"
  # The `:cannot_represent` is for a Digital Equipment Corporation license.
  # TODO: See if SPDX will consider this a match for HPND License.
  license all_of: [
    "GPL-1.0-or-later",
    "GPL-2.0-or-later", # ircd/fileio.*, ircd/patricia.c
    "ISC", # ircd/res_comp.c
    "BSD-4-Clause-UC", # ircd/{res_comp.c,res_init.c,res_mkquery.c,resolv_def.h}
    :cannot_represent, # ircd/{res_comp.c,res_init.c,res_mkquery.c,resolv_def.h}
  ]

  livecheck do
    url "http://www.irc.org/ftp/irc/server/"
    regex(/href=.*?irc[._-]?v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "531d4931922a5d7d0421a6d6de693ea17c43edf571839c3415e856c20f6b01e3"
    sha256 arm64_ventura:  "8ca253a45db11738e82beb74dac8f6bc70fa455f738ec1252de0102826247697"
    sha256 arm64_monterey: "9278b13e2b860697e5868ca1624103f2dc4d81b6bc0e6e58801c1bdb52bac550"
    sha256 arm64_big_sur:  "ed3eac7c4635484c94d12579948947bff1eb6a671846fcd9273dd5ed226759fa"
    sha256 sonoma:         "d8aa632b8c5493007c5911e292bb411c6b91c8d6526b1a0ceb5a75ec448cbc38"
    sha256 ventura:        "dc5322bc271aae9ea0b3c84981f73ddfde9602a453335fa3ed3f164b048373c1"
    sha256 monterey:       "d4c8fb409f40a0b28fd5058260e3ceef2520c654eda0398271e04a6fe9918c66"
    sha256 big_sur:        "855bb8b0254ee0f410d6bdf3ad8479900f39f0ad120145485d9bdbe146f7a399"
    sha256 catalina:       "35ae4defa513772b1e1b5b0400976d49cb213818a2272a9760a3da3a7e8c0765"
    sha256 mojave:         "e0522b8f4eb95b0d60527e136e69474b4e9fe6f2b77a12919d5a6dd76bb2a4fa"
    sha256 x86_64_linux:   "f8bad7fefb7315efe840f1f601b28ea1f9a83167fe40c8b9c5496330307363f6"
  end

  def default_ircd_conf
    <<~EOS
      # M-Line
      M:irc.localhost::Darwin ircd default configuration::000A

      # A-Line
      A:This is Darwin's default ircd configurations:Please edit your /usr/local/etc/ircd.conf file:Contact <root@localhost> for questions::ExampleNet

      # Y-Lines
      Y:1:90::100:512000:5.5:100.100
      Y:2:90::300:512000:5.5:250.250

      # I-Line
      I:*:::0:1
      I:127.0.0.1/32:::0:1

      # P-Line
      P::::6667:
    EOS
  end

  uses_from_macos "libxcrypt"

  conflicts_with "ircd-hybrid", because: "both install `ircd` binaries"

  # Replace usage of nameser_def.h which has incompatible IBM license.
  # Ref: https://gitlab.com/fedora/legal/fedora-license-data/-/issues/53
  patch :DATA

  def install
    # Remove header with incompatible IBM license and add linker flags to use system library instead
    rm("ircd/nameser_def.h")
    ENV.append "LIBS", "-lresolv"

    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "CFLAGS=-DRLIMIT_FDMAX=0"

    build_dir = `./support/config.guess`.chomp

    # Disable netsplit detection. In a netsplit, joins to new channels do not
    # give chanop status.
    inreplace "#{build_dir}/config.h", /#define DEFAULT_SPLIT_USERS\s+65000/,
      "#define DEFAULT_SPLIT_USERS 0"
    inreplace "#{build_dir}/config.h", /#define DEFAULT_SPLIT_SERVERS\s+80/,
      "#define DEFAULT_SPLIT_SERVERS 0"

    # The directory is something like `i686-apple-darwin13.0.2'
    system "make", "install", "-C", build_dir

    (buildpath/"ircd.conf").write default_ircd_conf
    etc.install "ircd.conf"
  end

  service do
    run [opt_sbin/"ircd", "-t"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    error_log_path var/"ircd.log"
  end

  test do
    system "#{sbin}/ircd", "-version"
  end
end

__END__
diff --git a/ircd/res_comp.c b/ircd/res_comp.c
index b58d06c..a0ff2b9 100644
--- a/ircd/res_comp.c
+++ b/ircd/res_comp.c
@@ -64,6 +64,7 @@ static const volatile char rcsid[] = "$Id: res_comp.c,v 1.10 2004/10/01 20:22:14
 #include "s_externs.h"
 #undef RES_COMP_C

+#if 0
 static int	ns_name_ntop (const u_char *, char *, size_t);
 static int	ns_name_pton (const char *, u_char *, size_t);
 static int	ns_name_unpack (const u_char *, const u_char *,
@@ -75,6 +76,7 @@ static int	ns_name_uncompress (const u_char *, const u_char *,
 static int	ns_name_compress (const char *, u_char *, size_t,
 				      const u_char **, const u_char **);
 static int	ns_name_skip (const u_char **, const u_char *);
+#endif

 /*
  * Expand compressed domain name 'comp_dn' to full domain name.
@@ -306,6 +308,7 @@ static int		dn_find (const u_char *, const u_char *,

 /* Public. */

+#if 0
 /*
  * ns_name_ntop(src, dst, dstsiz)
  *	Convert an encoded domain name to printable ascii as per RFC1035.
@@ -749,6 +752,7 @@ static int	ns_name_skip(const u_char **ptrptr, const u_char *eom)
 	*ptrptr = cp;
 	return (0);
 }
+#endif

 /* Private. */

diff --git a/ircd/s_defines.h b/ircd/s_defines.h
index aaaf0d4..acd1378 100644
--- a/ircd/s_defines.h
+++ b/ircd/s_defines.h
@@ -37,4 +37,5 @@
 #include "service_def.h"
 #include "sys_def.h"
 #include "resolv_def.h"
-#include "nameser_def.h"
+#define BIND_8_COMPAT
+#include <arpa/nameser.h>
