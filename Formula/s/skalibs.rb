class Skalibs < Formula
  desc "Skarnet's library collection"
  homepage "https://skarnet.org/software/skalibs/"
  url "https://skarnet.org/software/skalibs/skalibs-2.14.4.0.tar.gz"
  sha256 "0e626261848cc920738f92fd50a24c14b21e30306dfed97b8435369f4bae00a5"
  license "ISC"

  def install
    # Shared libraries are linux targets and not supported on macOS.
    args = %w[
      --disable-silent-rules
      --disable-shared
      --enable-pkgconfig
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <skalibs/skalibs.h>
      int main() {
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lskarnet", "-o", "test"
    system "./test"
  end
end
