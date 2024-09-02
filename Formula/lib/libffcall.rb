class Libffcall < Formula
  desc "GNU Foreign Function Interface library"
  homepage "https://www.gnu.org/software/libffcall/"
  url "https://ftp.gnu.org/gnu/libffcall/libffcall-2.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/libffcall/libffcall-2.5.tar.gz"
  sha256 "7f422096b40498b1389093955825f141bb67ed6014249d884009463dc7846879"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "81b1425ddfbafc4b45ea81966453bb799882b8416e5afb12782188b8fbe187ec"
    sha256 cellar: :any,                 arm64_ventura:  "a8c90eb0454270ad27198e6e90c0731f6afef51095ec621b80a7a043754822e0"
    sha256 cellar: :any,                 arm64_monterey: "91b71a704643bddb2ccd847f70bca71b2f4f42f15dfbe090163efb30e834e9aa"
    sha256 cellar: :any,                 sonoma:         "dd054182feae02cb566f5e587b1a8d325207d08ee4aea65d0fc1dc6b63c5fb3e"
    sha256 cellar: :any,                 ventura:        "5f46b88ad65430756cb72c1d4998af731850e1c5b1a8ddd7867f08f7c574af34"
    sha256 cellar: :any,                 monterey:       "40160028f3394161521a252e488bd7aaa5d2f08f226c794d3252d0d5e1622d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f068599b3b97c24dba0ebe1338f972e5de443b155dd2a174dcd516d7b8a39430"
  end

  def install
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
