class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.1.5.tar.gz"
  sha256 "7eafa9fd0dace499e80859867a6ba5a010816cf6e914dd9350ad1d44c0fc83eb"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc4fe0321fd865aa9b724677b2a15708c48ebe415f3bf7a68138e37a15f7260c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a645adf1b04ba4db24c7116d1d4302bd083cd0b597a12b5dbf2fa5602fa7cb88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "246d372bfa94a096adab1d03f8f729e26e998dc275a7a0d641d63e84b60d7aa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a67fdbd23d0e340f49c29f4de0a6a0b2b8c993da17951df794569dda1a66b1d"
    sha256 cellar: :any_skip_relocation, ventura:       "4416eead80e919d15b864ea020c7581d9c983b13006fa2b967df09ace5972bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e426af3f5f517010d449d5d2f8c37a72c4bdae04d6e7eb8d359b351419fd23d1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end
