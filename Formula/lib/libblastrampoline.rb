class Libblastrampoline < Formula
  desc "Using PLT trampolines to provide a BLAS and LAPACK demuxing library"
  homepage "https://github.com/JuliaLinearAlgebra/libblastrampoline"
  url "https://github.com/JuliaLinearAlgebra/libblastrampoline/archive/refs/tags/v5.12.0.tar.gz"
  sha256 "12f9d186bc844a21dfa2a6ea1f38a039227554330c43230d72f721c330cf6018"
  license all_of: [
    "MIT",
    "BSD-2-Clause-Views", # include/common/f77blas.h
    "BSD-3-Clause",       # include/common/lapacke*
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5cca09359f31b19b6b77d0a1341afc2387001ed0a69e1b9897da3f76cd076a1c"
    sha256 cellar: :any,                 arm64_sonoma:  "872b2a71d55408b090e0ff537a19e25478d20f3b8a8a9b5b2edf57168d28ce19"
    sha256 cellar: :any,                 arm64_ventura: "f25b9ea847e19bd005b8bb796d1abb61297edffccbcf1a5aaed437bda25c46cb"
    sha256 cellar: :any,                 sonoma:        "dc938e2e514a97763c66abe33134ce654beee21e708d78c7aaa72e25f3ceddc4"
    sha256 cellar: :any,                 ventura:       "c0f5076d913214cf8dca40fdedfa96f98a9d05fa120e1c88e4850dbf93691fd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc582b8a709a61f79ff32824c21a404426b7e1b4e2f4afc18f9fe0a3e6dd907c"
  end

  depends_on "openblas" => :test

  on_macos do
    # Work around build failure seen with Xcode 16 and LLVM 17-18.
    # Issue ref: https://github.com/JuliaLinearAlgebra/libblastrampoline/issues/139
    depends_on "llvm@16" => :build if DevelopmentTools.clang_build_version == 1600
  end

  def install
    # Compiler selection is not supported for versioned LLVM
    ENV["HOMEBREW_CC"] = Formula["llvm@16"].opt_bin/"clang" if DevelopmentTools.clang_build_version == 1600

    system "make", "-C", "src", "install", "prefix=#{prefix}"
    (pkgshare/"test").install "test/dgemm_test/dgemm_test.c"
  end

  test do
    cp pkgshare/"test/dgemm_test.c", testpath

    (testpath/"api_test.c").write <<~C
      #include <assert.h>
      #include <stdio.h>
      #include <libblastrampoline.h>

      int main() {
        const lbt_config_t * config = lbt_get_config();
        assert(config != NULL);

        lbt_library_info_t ** libs = config->loaded_libs;
        assert(libs != NULL);
        assert(sizeof(libs) == sizeof(lbt_library_info_t *));
        assert(libs[0] != NULL);

        printf("%s", libs[0]->libname);
        return 0;
      }
    C

    system ENV.cc, "dgemm_test.c", "-I#{include}", "-L#{lib}", "-lblastrampoline", "-o", "dgemm_test"
    system ENV.cc, "api_test.c", "-I#{include}", "-L#{lib}", "-lblastrampoline", "-o", "api_test"

    test_libs = [shared_library("libopenblas")]
    if OS.mac?
      test_libs << "/System/Library/Frameworks/Accelerate.framework/Accelerate"
      ENV["DYLD_LIBRARY_PATH"] = Formula["openblas"].opt_lib.to_s
    end

    test_libs.each do |test_lib|
      with_env(LBT_DEFAULT_LIBS: test_lib) do
        assert_equal test_lib, shell_output("./api_test")
        system "./dgemm_test"
      end
    end
  end
end
