class Beagle < Formula
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "9d258cd9bedd86d7c28b91587acd1132f4e01d4f095c657ad4dc93bd83d4f120"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "68b15491189b2d39203b4675128f67e2757f7c32a61fd6771495ad634ec1b1f3"
    sha256 cellar: :any,                 arm64_sonoma:   "b6d8ccd22a1a3dd0fc66aa753d774382005e10a6c92102af898a8c48a249e2d6"
    sha256 cellar: :any,                 arm64_ventura:  "3d83a1652998bf200c2b1a7942fb3946d751a9d647f46b1275109e49c48be695"
    sha256 cellar: :any,                 arm64_monterey: "8ec46e2c91cff30977deec35fc3e01707f11f81960075c16da25edb8a6f9ca8c"
    sha256 cellar: :any,                 sonoma:         "da4b28f050e38cfafa7cdcfaef9cec21e01f9335a609ea2e415357c8fe901da4"
    sha256 cellar: :any,                 ventura:        "b59a52ec3fac58ea5c9e1b9e9240befe1f3d81fb30803c8c1028047f3d192cdb"
    sha256 cellar: :any,                 monterey:       "ab9a7a95580ffe99fde279ce650f66a39fc3f1065c9cf767feb4b2bec6f71b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a8fce3c841addff79fd9d784f923a29b7e5f3549ce75b91c2d895f83542411c"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => [:build, :test]

  def install
    # Avoid building Linux bottle with `-march=native`. Need to enable SSE4.1 for _mm_dp_pd
    # Issue ref: https://github.com/beagle-dev/beagle-lib/issues/189
    inreplace "CMakeLists.txt", "-march=native", "-msse4.1" if OS.linux? && build.bottle?

    ENV["JAVA_HOME"] = Language::Java.java_home
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/tinytest/tinytest.cpp"
  end

  test do
    if OS.mac? && Hardware::CPU.arm? && Hardware::CPU.virtualized?
      # OpenCL is not supported on virtualized arm64 macOS which breaks all Beagle functionality
      (testpath/"test.cpp").write <<~CPP
        #include <iostream>
        #include "libhmsbeagle/beagle.h"
        int main() {
          std::cout << beagleGetVersion();
          return 0;
        }
      CPP
      system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}/libhmsbeagle-1", "-L#{lib}", "-lhmsbeagle"
      assert_match version.to_s, shell_output("./test")
    else
      system ENV.cxx, pkgshare/"tinytest.cpp", "-o", "test", "-I#{include}/libhmsbeagle-1", "-L#{lib}", "-lhmsbeagle"
      assert_match "sumLogL = -1498.", shell_output("./test")
    end

    (testpath/"T.java").write <<~JAVA
      class T {
        static { System.loadLibrary("hmsbeagle-jni"); }
        public static void main(String[] args) {}
      }
    JAVA
    system Formula["openjdk"].bin/"javac", "T.java"
    system Formula["openjdk"].bin/"java", "-Djava.library.path=#{lib}", "T"
  end
end
