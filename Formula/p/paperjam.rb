class Paperjam < Formula
  desc "Program for transforming PDF files"
  homepage "https://mj.ucw.cz/sw/paperjam/"
  url "https://mj.ucw.cz/download/linux/paperjam-1.2.1.tar.gz"
  sha256 "bd38ed3539011f07e8443b21985bb5cd97c656e12d9363571f925d039124839b"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?paperjam[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1173139f00d87d9853a76d10a2c05b0ab451e5d5388582cf3d10291d8b70a66e"
    sha256 cellar: :any,                 arm64_sonoma:  "39c2d7a60e6ccc75a168b7e0be8696b91a033fd360d426403ab50e20df7043ee"
    sha256 cellar: :any,                 arm64_ventura: "e879f41bf1c0ef0f824e302e2515b921fe9009de00de18c2ba2035c259b2f90c"
    sha256 cellar: :any,                 sonoma:        "a6d35687e6f83ac011a32b169878d55656477a5db46531a5d9a80e46ffafa303"
    sha256 cellar: :any,                 ventura:       "7823de97267e2efebc6efaba7ae5c4448269d79c98ab613c6115c1d033cfce5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecb416231708d36a49ec9dd59319a9cf9ae1443d3c962f16b8b4d514d3b12d7d"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libpaper"
  depends_on "qpdf"

  uses_from_macos "libxslt"

  # notified the upstream about the patch
  patch :DATA

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDLIBS", "-liconv" if OS.mac?
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"paperjam", "modulo(2) { 1, 2: rotate(180) }", test_fixtures("test.pdf"), "output.pdf"
    assert_path_exists testpath/"output.pdf"
  end
end

__END__
diff --git a/pdf-tools.cc b/pdf-tools.cc
index 0d74ca3..23d5ee4 100644
--- a/pdf-tools.cc
+++ b/pdf-tools.cc
@@ -7,6 +7,7 @@
 #include <cstdio>
 #include <cstdlib>
 #include <cstring>
+#include <memory>

 #include <iconv.h>

@@ -229,7 +230,7 @@ QPDFObjectHandle page_to_xobject(QPDF *out, QPDFObjectHandle page)
 	}

 	vector<QPDFObjectHandle> contents = page.getPageContents();
-	auto ph = PointerHolder<QPDFObjectHandle::StreamDataProvider>(new CombineFromContents_Provider(contents));
+	auto ph = std::shared_ptr<QPDFObjectHandle::StreamDataProvider>(new CombineFromContents_Provider(contents));
 	xo_stream.replaceStreamData(ph, QPDFObjectHandle::newNull(), QPDFObjectHandle::newNull());
 	return xo_stream;
 }
diff --git a/pdf.cc b/pdf.cc
index 9f8dc12..41a158b 100644
--- a/pdf.cc
+++ b/pdf.cc
@@ -185,7 +185,11 @@ static void make_info_dict()
     {
       const string to_copy[] = { "/Title", "/Author", "/Subject", "/Keywords", "/Creator", "/CreationDate" };
       for (string key: to_copy)
-	info.replaceOrRemoveKey(key, orig_info.getKey(key));
+        {
+          QPDFObjectHandle value = orig_info.getKey(key);
+          if (!value.isNull())
+            info.replaceKey(key, value);
+        }
     }
 }
