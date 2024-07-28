class Libtirpc < Formula
  desc "Port of Sun's Transport-Independent RPC library to Linux"
  homepage "https://sourceforge.net/projects/libtirpc/"
  url "https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.3.5/libtirpc-1.3.5.tar.bz2"
  sha256 "9b31370e5a38d3391bf37edfa22498e28fe2142467ae6be7a17c9068ec0bf12f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ddd04177b907c57c70393dae0ce340dd1fa73c3824adfac4a24325661096a8bf"
  end

  depends_on "krb5"
  depends_on :linux

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rpc/rpc.h>
      #include <rpc/xdr.h>
      #include <stdio.h>

      int main() {
        XDR xdr;
        char buf[256];
        xdrmem_create(&xdr, buf, sizeof(buf), XDR_ENCODE);
        int i = 42;
        xdr_destroy(&xdr);
        printf("xdr_int succeeded");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/tirpc", "-ltirpc", "-o", "test"
    system "./test"
  end
end
