class AwsChecksums < Formula
  desc "Cross-Platform HW accelerated CRC32c and CRC32 with fallback"
  homepage "https://github.com/awslabs/aws-checksums"
  url "https://github.com/awslabs/aws-checksums/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "3e8ba6ac207fde5aacaa0cc77902bd5b52dde59fd3d5513745173f9882fd4696"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ac30d6299f02a1ede0eee6ffa20a3f7b08e76ac05064a655b5bd319c5539f94"
    sha256 cellar: :any,                 arm64_sonoma:  "63708a75992ce707ff4b65c03568480d3435e41d133e3935883ff91a0ea25fde"
    sha256 cellar: :any,                 arm64_ventura: "b2c36d7d1316505097e5985008d7673ab2952c849a4b0bb31d316759cc0130df"
    sha256 cellar: :any,                 sonoma:        "0b8f619e7e39a3b7bba9da8058a489137f86356534793068c4a69cee9eb0c24a"
    sha256 cellar: :any,                 ventura:       "9d3451c36ad1dad9dc99fc39d6906f37c3eec03848a3a056c377d33ab1a4c581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "370485b20a91bb888ad3fffb7450295d6d78d4330871dc76e336c189e2c20bba"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/checksums/crc.h>
      #include <aws/common/allocator.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        const size_t len = 3 * 1024 * 1024 * 1024ULL;
        const uint8_t *many_zeroes = aws_mem_calloc(allocator, len, sizeof(uint8_t));
        uint32_t result = aws_checksums_crc32_ex(many_zeroes, len, 0);
        aws_mem_release(allocator, (void *)many_zeroes);
        assert(0x480BBE37 == result);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-checksums",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
