class Libcotp < Formula
  desc "C library that generates TOTP and HOTP"
  homepage "https://github.com/paolostivanin/libcotp"
  url "https://github.com/paolostivanin/libcotp/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "a48bbfd95b7ec12d23e4e2c4a017f8acddecc14bf10541ff144563cee044b39c"
  license "Apache-2.0"
  head "https://github.com/paolostivanin/libcotp.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libgcrypt"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <cotp.h>

      int main() {
        const char *K = "12345678901234567890";
        const int64_t counter[] = {59, 1111111109, 1111111111, 1234567890, 2000000000, 20000000000};

        cotp_error_t cotp_err;
        char *K_base32 = base32_encode((const uchar *)K, strlen(K)+1, &cotp_err);

        cotp_error_t err;
        for (int i = 0; i < 6; i++) {
          printf("%s\\n", get_totp_at(K_base32, counter[i], 8, 30, SHA1, &err));
        }

        free(K_base32);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcotp", "-o", "test"

    expected_output = %w[94287082 07081804 14050471 89005924 69279037 65353130]
    assert_equal expected_output, shell_output("./test").split("\n")
  end
end
