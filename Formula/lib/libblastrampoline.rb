class Libblastrampoline < Formula
  desc "Using PLT trampolines to provide a BLAS and LAPACK demuxing library"
  homepage "https://github.com/JuliaLinearAlgebra/libblastrampoline"
  url "https://github.com/JuliaLinearAlgebra/libblastrampoline/archive/refs/tags/v5.11.0.tar.gz"
  sha256 "4ea6c134843bd868f78d7ee0c61bf8bdda5334f20deaa6d3cd5bc6caafc4af17"
  license all_of: [
    "MIT",
    "BSD-2-Clause-Views", # include/common/f77blas.h
    "BSD-3-Clause",       # include/common/lapacke*
  ]

  depends_on "openblas" => :test

  def install
    system "make", "-C", "src", "install", "prefix=#{prefix}"
    (pkgshare/"test").install "test/dgemm_test/dgemm_test.c"
  end

  test do
    cp pkgshare/"test/dgemm_test.c", testpath

    (testpath/"api_test.c").write <<~EOS
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
    EOS

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
