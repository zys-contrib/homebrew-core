class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  url "https://github.com/ivmai/bdwgc/releases/download/v8.2.8/gc-8.2.8.tar.gz"
  sha256 "7649020621cb26325e1fb5c8742590d92fb48ce5c259b502faf7d9fb5dabb160"
  license "MIT"
  head "https://github.com/ivmai/bdwgc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1a7412a4f307af48d738d4e6d4fe92bdd0837f483f8b540463b9fbe04f3af7f5"
    sha256 cellar: :any,                 arm64_sonoma:   "6ba6ddd8c881ecca1b67e30767731cefdeffd8244400f7168b1f219b3feba6b9"
    sha256 cellar: :any,                 arm64_ventura:  "2444d8be228c05dfcaee2f03c8ff804e9ce3e808af6b3673e11428e5f62a7ffa"
    sha256 cellar: :any,                 arm64_monterey: "d98f35081558a6411f47913a4da75a1d72449e08534ea27e113f3872b52654b2"
    sha256 cellar: :any,                 sonoma:         "b865f1118d74c14ec1f714cf7bbf290e8e33d7ddeb2cb12f82558cfc3cb82d0c"
    sha256 cellar: :any,                 ventura:        "e3e095294699381bb6285ed2167a8b7fdfa339f78d06b8d99a1b6a6d3295bae0"
    sha256 cellar: :any,                 monterey:       "9f2c45bbb24805adaec4a3be2cbedad416ec8ff46a8ea558e1e11c0b7cec3ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58a7a7fde3f5f86d93087ca5484c1dc1b6f11089dc696ff1b83efebf82969cd6"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -Denable_cplusplus=ON
      -Denable_large_config=ON
      -Dwithout_libatomic_ops=OFF
      -Dwith_libatomic_ops=OFF
    ]

    system "cmake", "-S", ".", "-B", "build",
                    "-Dbuild_tests=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args,
                    "-DBUILD_TESTING=ON" # Pass this *after* `std_cmake_args`
    system "cmake", "--build", "build"
    if OS.linux? || Hardware::CPU.arm? || MacOS.version > :monterey
      # Fails on 12-x86_64.
      system "ctest", "--test-dir", "build",
                      "--parallel", ENV.make_jobs,
                      "--rerun-failed",
                      "--output-on-failure"
    end
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install buildpath.glob("build-static/*.a")
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>
      #include "gc.h"

      int main(void)
      {
        int i;

        GC_INIT();
        for (i = 0; i < 10000000; ++i)
        {
          int **p = (int **) GC_MALLOC(sizeof(int *));
          int *q = (int *) GC_MALLOC_ATOMIC(sizeof(int));
          assert(*p == 0);
          *p = (int *) GC_REALLOC(q, 2 * sizeof(int));
        }
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgc", "-o", "test"
    system "./test"
  end
end
