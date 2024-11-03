class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.20.0",
      revision: "c4fb724e810bb496165b9015c77f402727392933"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d97103bb5f94fab8a364c031879f186079ec34ff3e3034d9f9a9d941cfa7ba99"
    sha256 cellar: :any,                 arm64_ventura:  "7515067567fb810bd6a49b9b221458cd6a7c377e220279f199151808a9e1bfc1"
    sha256 cellar: :any,                 arm64_monterey: "b9963245e88af5ef863bcf0e8d28c078c312ab31d330eae4e69c243837281ec4"
    sha256 cellar: :any,                 sonoma:         "31bd37397424abc33c1981dede657ba0f1b7209262c70854b774841857809b88"
    sha256 cellar: :any,                 ventura:        "eab070cc7924e3b5d38277f24b3313c4b181e6fd9a7f4f8e0f539a057ff1f544"
    sha256 cellar: :any,                 monterey:       "aa8b359507d4b024ce46baadf0c75772fe1ba6ffb3e43551cf6e3d6b7a487fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dde778dd1564940af7b2116cba7d4c8b45b4d6e335c78620cf97b1e1e6a688b1"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "cpp-gsl" => :build
  depends_on "flatbuffers" => :build # NOTE: links to static library
  depends_on "howard-hinnant-date" => :build
  depends_on "nlohmann-json" => :build
  depends_on "python@3.13" => :build
  depends_on "safeint" => :build
  depends_on "abseil"
  depends_on "nsync"
  depends_on "protobuf@21" # https://github.com/microsoft/onnxruntime/issues/21308
  depends_on "re2"

  # Need newer than stable `eigen` after https://github.com/microsoft/onnxruntime/pull/21492
  # element_wise_ops.cc:708:32: error: no matching member function for call to 'min'
  #
  # https://github.com/microsoft/onnxruntime/blob/v#{version}/cmake/deps.txt#L25
  resource "eigen" do
    url "https://gitlab.com/libeigen/eigen/-/archive/e7248b26a1ed53fa030c5c459f7ea095dfd276ac/eigen-e7248b26a1ed53fa030c5c459f7ea095dfd276ac.tar.bz2"
    sha256 "a3f1724de1dc7e7f74fbcc206ffcaeba27fd89b37dc71f9c31e505634d0c1634"
  end

  # https://github.com/microsoft/onnxruntime/blob/v#{version}/cmake/deps.txt#L52
  resource "pytorch_cpuinfo" do
    url "https://github.com/pytorch/cpuinfo/archive/ca678952a9a8eaa6de112d154e8e104b22f9ab3f.tar.gz"
    sha256 "c8f43b307fa7d911d88fec05448161eb1949c3fc0cb62f3a7a2c61928cdf2e9b"
  end

  # TODO: Consider making separate formula
  resource "onnx" do
    url "https://github.com/onnx/onnx/archive/refs/tags/v1.17.0.tar.gz"
    sha256 "8d5e983c36037003615e5a02d36b18fc286541bf52de1a78f6cf9f32005a820e"
  end

  # Fix build on Linux
  # TODO: Upstream if it works
  patch :DATA

  def install
    python3 = which("python3.13")

    # Workaround to use brew `nsync`. Remove in future release with
    # https://github.com/microsoft/onnxruntime/commit/88676e62b966add2cc144a4e7d8ae1dbda1148e8
    inreplace "cmake/external/onnxruntime_external_deps.cmake" do |s|
      s.gsub!(/ NAMES nsync unofficial-nsync$/, " NAMES nsync_cpp")
      s.gsub!(/\bunofficial::nsync::nsync_cpp\b/, "nsync_cpp")
    end

    resources.each do |r|
      (buildpath/"build/_deps/#{r.name}-src").install r
    end

    args = %W[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_SOURCE_DIR_PYTORCH_CLOG=#{buildpath}/build/_deps/pytorch_cpuinfo-src
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DPYTHON_EXECUTABLE=#{python3}
      -DONNX_CUSTOM_PROTOC_EXECUTABLE=#{Formula["protobuf@21"].opt_bin}/protoc
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_USE_FULL_PROTOBUF=ON
    ]

    # Regenerate C++ bindings to use newer `flatbuffers`
    flatc = Formula["flatbuffers"].opt_bin/"flatc"
    system python3, "onnxruntime/core/flatbuffers/schema/compile_schema.py", "--flatc", flatc
    system python3, "onnxruntime/lora/adapter_format/compile_schema.py", "--flatc", flatc

    system "cmake", "-S", "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <onnxruntime/onnxruntime_c_api.h>
      #include <stdio.h>
      int main()
      {
        printf("%s\\n", OrtGetApiBase()->GetVersionString());
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lonnxruntime", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end

__END__
diff --git a/onnxruntime/core/optimizer/transpose_optimization/onnx_transpose_optimization.cc b/onnxruntime/core/optimizer/transpose_optimization/onnx_transpose_optimization.cc
index 470838d36e..81a842eb87 100644
--- a/onnxruntime/core/optimizer/transpose_optimization/onnx_transpose_optimization.cc
+++ b/onnxruntime/core/optimizer/transpose_optimization/onnx_transpose_optimization.cc
@@ -5,6 +5,7 @@
 
 #include <algorithm>
 #include <cassert>
+#include <cstring>
 #include <iostream>
 #include <memory>
 #include <unordered_map>
