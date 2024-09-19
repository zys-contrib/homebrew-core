class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.1.4.tar.gz"
  sha256 "fc15ac958e3c7778c6bed713fde849c09e8526f6274140d25ed4adc92331fa68"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "967042752c7605e534f87bca5c3632098623306cee024e5de9e5838aacb04268"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82df8f915a7cd9b4ff6638237c18d16f192d68b916e173642580b5f83353e535"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b5d797ea9e398c7a93fe285055a61a9588b60de2ac6e1c987c7a5f23cc3a1ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "137b0e9857c94d8a0ca91976d4bdfdf95b79db199b1621a8b7e064d1713c202d"
    sha256 cellar: :any_skip_relocation, ventura:       "996fc9f22c54acfb30699b5d022c15fbe0518743adf82da2320a383eb91a9fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa568ff2977e2128694a8efd43624b7089a998b1e4476a6c8651f52fe46810bd"
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
