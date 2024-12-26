class Sse2neon < Formula
  desc "Translator from Intel SSE intrinsics to Arm/Aarch64 NEON implementation"
  homepage "https://github.com/DLTcollab/sse2neon"
  url "https://github.com/DLTcollab/sse2neon/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "e251746e3b761f3f0de1ad462b1efe53532341b6b0498d394765fceb85ce8a46"
  license "MIT"
  head "https://github.com/DLTcollab/sse2neon.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "f42189e7b34ec8c8206fc17382c113f36c236afae45502f7faf852a7fccdd2f7"
  end

  depends_on arch: :arm64

  def install
    (include/"sse2neon").install "sse2neon.h"
    include.install_symlink "sse2neon/sse2neon.h"
  end

  test do
    %w[sse2neon sse2neon/sse2neon].each do |include_path|
      test_name = include_path.tr("/", "-")
      (testpath/"#{test_name}.c").write <<~C
        #include <assert.h>
        #include <#{include_path}.h>

        int main() {
          int64_t a = 1, b = 2;
          assert(vaddd_s64(a, b) == 3);
          __m128i z = _mm_setzero_si128();
          __m128i v = _mm_undefined_si128();
          v = _mm_xor_si128(v, v);
          assert(_mm_movemask_epi8(_mm_cmpeq_epi8(v, z)) == 0xFFFF);
          return 0;
        }
      C

      system ENV.cc, "#{test_name}.c", "-o", test_name
      system testpath/test_name
    end
  end
end
