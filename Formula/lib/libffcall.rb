class Libffcall < Formula
  desc "GNU Foreign Function Interface library"
  homepage "https://www.gnu.org/software/libffcall/"
  url "https://ftp.gnu.org/gnu/libffcall/libffcall-2.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/libffcall/libffcall-2.4.tar.gz"
  sha256 "8ef69921dbdc06bc5bb90513622637a7b83a71f31f5ba377be9d8fd8f57912c2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb0b3113b4075bd871c9dbc7c1c0af213e77b700aaedc4cf5532b1944015defc"
    sha256 cellar: :any,                 arm64_monterey: "58dd56d1ab429bde2b8078bb3737682b57a37a7d67b70e8c27bcc023f988e2fd"
    sha256 cellar: :any,                 arm64_big_sur:  "d7ace5f73fe02c38febe33718fbb293e765f7d1909763b39dc280d410e2a1488"
    sha256 cellar: :any,                 sonoma:         "3b70f3916012c4240807ddb397c4138d174367c587b6814b7f1970a282f2569e"
    sha256 cellar: :any,                 ventura:        "ee2b7df162625a59cd9ac90a61a91a238138cf244a385c1c94dc50d90319d546"
    sha256 cellar: :any,                 monterey:       "947d7c231e88bbf9a4037e15c75abb158334b895efb9ea15e698e340e0d95f6b"
    sha256 cellar: :any,                 big_sur:        "61cb42231c842a5559808582e374420e058fe76cc60b47f08b383c2751536caa"
    sha256 cellar: :any,                 catalina:       "1412d8bb030690981a6322f18a3ef686aaa3f7b1ab3e390be2767e83cb5160a5"
    sha256 cellar: :any,                 mojave:         "093534e26c77187ebd27234802635357c458cfe6956edc618d6292e707bc5fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b9ade24ffa94a150150dd446d25f7fdee0497c98d334cbf9d4b3cc0ed649990"
  end

  # Backport fix needed to build on Sonoma ARM
  on_arm do
    on_sonoma :or_newer do
      depends_on "autoconf" => :build
      depends_on "automake" => :build
      depends_on "libtool" => :build

      patch :DATA # minimal diff to apply following commit
      patch do
        url "https://git.savannah.gnu.org/gitweb/?p=libffcall.git;a=patch;h=b35777b44209c0fa94f70320d9c7054220f31acb"
        sha256 "a120b64c77a8c493f6fc00545cc2c689cde16d009141590ad8fad0f0336124cc"
      end
    end
  end

  def install
    if Hardware::CPU.arm? && OS.mac? && MacOS.version >= :sonoma
      cp Formula["libtool"].share.glob("aclocal/*"), buildpath/"m4"
      system "autoreconf", "--force", "--install", "--verbose", "-I", "gnulib-m4", "-I", "m4"
    end
    ENV.deparallelize
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"callback.c").write <<~EOS
      #include <stdio.h>
      #include <callback.h>

      typedef char (*char_func_t) ();

      void function (void *data, va_alist alist)
      {
        va_start_char(alist);
        va_return_char(alist, *(char *)data);
      }

      int main() {
        char *data = "abc";
        callback_t callback = alloc_callback(&function, data);
        printf("%s\\n%c\\n",
          is_callback(callback) ? "true" : "false",
          ((char_func_t)callback)());
        free_callback(callback);
        return 0;
      }
    EOS
    flags = ["-L#{lib}", "-lffcall", "-I#{lib}/libffcall-#{version}/include"]
    system ENV.cc, "-o", "callback", "callback.c", *(flags + ENV.cflags.to_s.split)
    output = shell_output("#{testpath}/callback")
    assert_equal "true\na\n", output
  end
end

__END__
diff --git a/ChangeLog b/ChangeLog
index eda04ef..0510f3e 100644
--- a/ChangeLog
+++ b/ChangeLog
@@ -1,3 +1,7 @@
+2024-07-12  Bruno Haible  <bruno@clisp.org>
+
+	Switch to autoconf 2.72, automake 1.17.
+
 2021-06-13  Bruno Haible  <bruno@clisp.org>

 	Prepare for 2.4 release.
diff --git a/NEWS b/NEWS
index 5911682..d3dc00e 100644
--- a/NEWS
+++ b/NEWS
@@ -1,3 +1,7 @@
+* Added support for the following platforms:
+  (Previously, a build on these platforms failed.)
+  - loongarch64: Linux with lp64d ABI.
+
 New in 2.4:

 * Added support for the following platforms:
diff --git a/callback/trampoline_r/trampoline.c b/callback/trampoline_r/trampoline.c
index 5d4f8c2..089ce24 100644
--- a/callback/trampoline_r/trampoline.c
+++ b/callback/trampoline_r/trampoline.c
@@ -1,7 +1,7 @@
 /* Trampoline construction */

 /*
- * Copyright 1995-2021 Bruno Haible <bruno@clisp.org>
+ * Copyright 1995-2022 Bruno Haible <bruno@clisp.org>
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/m4/codeexec.m4 b/m4/codeexec.m4
index 4bf8a73..16a59af 100644
--- a/m4/codeexec.m4
+++ b/m4/codeexec.m4
@@ -1,5 +1,5 @@
 dnl -*- Autoconf -*-
-dnl Copyright (C) 1993-2020 Free Software Foundation, Inc.
+dnl Copyright (C) 1993-2023 Free Software Foundation, Inc.
 dnl This file is free software, distributed under the terms of the GNU
 dnl General Public License as published by the Free Software Foundation;
 dnl either version 2 of the License, or (at your option) any later version.
diff --git a/trampoline/trampoline.c b/trampoline/trampoline.c
index 9b79e0d..7147c5f 100644
--- a/trampoline/trampoline.c
+++ b/trampoline/trampoline.c
@@ -1,7 +1,7 @@
 /* Trampoline construction */

 /*
- * Copyright 1995-2021 Bruno Haible <bruno@clisp.org>
+ * Copyright 1995-2022 Bruno Haible <bruno@clisp.org>
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
