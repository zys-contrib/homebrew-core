class AmplAsl < Formula
  desc "AMPL Solver Library"
  homepage "https://www.ampl.com/"
  url "https://github.com/ampl/asl/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "28426e67b610874bbf8fd71fae982921aafe42310ef674c86aa6ec1181472ad0"
  license "BSD-3-Clause"

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
    ]
    args << "-DUSE_LTO=OFF" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include "asl/asl.h"

      int main() {
          void* asl_instance = malloc(sizeof(void));
          free(asl_instance);
          return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}/asl", "-L#{lib}", "-lasl"
    system "./test"
  end
end
