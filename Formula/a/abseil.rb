class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20240722.0.tar.gz"
  sha256 "f50e5ac311a81382da7fa75b97310e4b9006474f9560ac46f54a9967f07d4ae3"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f81e5b4e59baadeeb034b9e3ab39bfd6fa3452ba040454b20bc7be02f04e3f1"
    sha256 cellar: :any,                 arm64_ventura:  "4df3835a2f07aa349e5642ac25f680a825a9354252882a22119c027667dcf1b9"
    sha256 cellar: :any,                 arm64_monterey: "22261c6210c1f61544c473e07f72fa9b6d8eaa9ff071de86727698678e27fdd0"
    sha256 cellar: :any,                 sonoma:         "8067cb2758fa425cf8f8bb6f54a7ce623adf88dfcada2de56f99cd5e32648037"
    sha256 cellar: :any,                 ventura:        "98ccb8fc65de2133f4ddee9261e5ec9e10d8af5cb5adc58a0f8ddda7465eaa37"
    sha256 cellar: :any,                 monterey:       "51f2422d7012a1de5a8b16a7b443207cefa7d3a9331f14b8c449f4bdbe655b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9047cdcf5ca116319459936eea3e768ab1498b63195a9484cf283bb263ee74f"
  end

  depends_on "cmake" => [:build, :test]

  on_macos do
    depends_on "googletest" => :build # For test helpers
  end

  fails_with gcc: "5" # C++17

  # Fix shell option group handling in pkgconfig files
  # https://github.com/abseil/abseil-cpp/pull/1738
  patch do
    url "https://github.com/abseil/abseil-cpp/commit/9dfde0e30a2ce41077758e9c0bb3ff736d7c4e00.patch?full_index=1"
    sha256 "94a9b4dc980794b3fba0a5e4ae88ef52261240da59a787e35b207102ba4ebfcd"
  end

  def install
    ENV.runtime_cpu_detection

    # Install test helpers. Doing this on Linux requires rebuilding `googltest` with `-fPIC`.
    extra_cmake_args = if OS.mac?
      %w[ABSL_BUILD_TEST_HELPERS ABSL_USE_EXTERNAL_GOOGLETEST ABSL_FIND_GOOGLETEST].map do |arg|
        "-D#{arg}=ON"
      end
    end.to_a

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DABSL_PROPAGATE_CXX_STD=ON",
                    "-DABSL_ENABLE_INSTALL=ON",
                    *extra_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello_world.cc").write <<~EOS
      #include <iostream>
      #include <string>
      #include <vector>
      #include "absl/strings/str_join.h"

      int main() {
        std::vector<std::string> v = {"foo","bar","baz"};
        std::string s = absl::StrJoin(v, "-");

        std::cout << "Joined string: " << s << "\\n";
      }
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.16)

      project(my_project)

      # Abseil requires C++14
      set(CMAKE_CXX_STANDARD 14)

      find_package(absl REQUIRED)

      add_executable(hello_world hello_world.cc)

      # Declare dependency on the absl::strings library
      target_link_libraries(hello_world absl::strings)
    EOS
    system "cmake", testpath
    system "cmake", "--build", testpath, "--target", "hello_world"
    assert_equal "Joined string: foo-bar-baz\n", shell_output("#{testpath}/hello_world")
  end
end
