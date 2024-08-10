class Librcsc < Formula
  desc "RoboCup Soccer Simulator library"
  homepage "https://github.com/helios-base/librcsc"
  url "https://github.com/helios-base/librcsc/archive/refs/tags/rc2024.tar.gz"
  sha256 "81a3f86c9727420178dd936deb2994d764c7cd4888a2150627812ab1b813531b"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "0b8a58835ad594228751783935808aafdb3117be0a1e4b10754313a02f9d0ff3"
    sha256 cellar: :any,                 arm64_ventura:  "843e8fa7ea1ce56071294f4a7b833ba4367ae3bb6363af83aeaae7f6d52d7636"
    sha256 cellar: :any,                 arm64_monterey: "6ed80637e973c59168c069fabeec0634448c8c161120c886f62cc3a498a5784e"
    sha256 cellar: :any,                 arm64_big_sur:  "833fe11162a367e783177275011d5156933cb33c29c34d423237a253214f5552"
    sha256 cellar: :any,                 sonoma:         "264a3d386346e2c76b4f4815a30f594a40333ce771cd2839cb1cd1ff4c701f96"
    sha256 cellar: :any,                 ventura:        "6ac4c039117d05a0abdbcdfc09ac868667491fb670690929fc2597ffeeedf6fc"
    sha256 cellar: :any,                 monterey:       "5997731a4b6f409b301ea5014d41e53611048a5c8b8e59c78a31fba4f74626c0"
    sha256 cellar: :any,                 big_sur:        "e1af394e5832c69c864b55aece45a9a3a29664f32d28a20fb18f3e809eb01a31"
    sha256 cellar: :any,                 catalina:       "621b412c1c5c6623fef7b37e179dc75b47169b4a1007384aa2985daee09d6176"
    sha256 cellar: :any,                 mojave:         "0eeb0dfb16662da2760d8c753dc23049afdd9a8da0a5ae3eba9c5ac56ed00a41"
    sha256 cellar: :any,                 high_sierra:    "4bd96acb6e78620e25b3b33e745e7770ea812cde22a3d756ac978c778d3b993c"
    sha256 cellar: :any,                 sierra:         "c8b9dc2887f771f07b33bb70cec9ab62b4cee067f8b3a2d7ae57296428881031"
    sha256 cellar: :any,                 el_capitan:     "c2093c232c857c15bea5dd6c1c6df14aa4b00ed0c6eb3ab7e4d0d3f8c72b54c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6084c66b0de10b5c51e6094bfbf800fc8f7982354c3e64eb27122ae741b8fa9f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  uses_from_macos "zlib"

  # Add missing header to fix build on Monterey
  # Issue ref: https://github.com/helios-base/librcsc/issues/88
  patch :DATA

  def install
    system "./bootstrap"
    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <rcsc/rcg.h>
      int main() {
        rcsc::rcg::PlayerT p;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-lrcsc"
    system "./test"
  end
end

__END__
diff --git a/rcsc/rcg/parser_simdjson.cpp b/rcsc/rcg/parser_simdjson.cpp
index 47c9d2c..8218669 100644
--- a/rcsc/rcg/parser_simdjson.cpp
+++ b/rcsc/rcg/parser_simdjson.cpp
@@ -43,6 +43,7 @@

 #include <string_view>
 #include <functional>
+#include <unordered_map>

 namespace rcsc {
 namespace rcg {
