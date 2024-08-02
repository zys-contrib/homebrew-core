class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20240410.tar.gz"
  sha256 "328fe282b98457d85ab56184fa896467f6bf640d4e48e91fcefc8d31889f92b7"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c755bb8a253acb8402768359e19ec44c8f4e65d8791c22e645fc38debe61f1e5"
    sha256 cellar: :any,                 arm64_ventura:  "fbe0ee5d7e94128a904cb5a71b9454fe0513f6d679f3d39fcbb78c6f28e07a16"
    sha256 cellar: :any,                 arm64_monterey: "e58fbec7d849778eb9be9c7f8f50358adb47643aadc1f1ca34c804112127e988"
    sha256 cellar: :any,                 sonoma:         "51ec869bf851e0a8fc28d881438b31dc42eb28bdf97621686da3163f20ca8980"
    sha256 cellar: :any,                 ventura:        "561c23f71d29b0789212d7d42fb4054980ef051501cca51b74f25ade9f7eb0e3"
    sha256 cellar: :any,                 monterey:       "81902cc99d750d7194e194d113cbb381ad8bcd6ee93a341ac2e6387e1c1d2ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d250f18900053b0923203563b64270cda2e78cd43bbb5d5008719365ccfebc08"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  on_macos do
    depends_on "vulkan-headers" => [:build, :test]
    depends_on "abseil"
    depends_on "glslang"
    depends_on "libomp"
    depends_on "molten-vk"
    depends_on "spirv-tools"
  end

  def install
    # fix `libabsl_log_internal_check_op.so.2301.0.0: error adding symbols: DSO missing from command line` error
    # https://stackoverflow.com/a/55086637
    ENV.append "LDFLAGS", "-Wl,--copy-dt-needed-entries" if OS.linux?

    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
      -DNCNN_SHARED_LIB=ON
      -DNCNN_BUILD_BENCHMARK=OFF
      -DNCNN_BUILD_EXAMPLES=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    if OS.mac?
      args += %W[
        -DNCNN_SYSTEM_GLSLANG=ON
        -DGLSLANG_TARGET_DIR=#{Formula["glslang"].opt_lib/"cmake"}
        -DNCNN_VULKAN=ON
        -DVulkan_INCLUDE_DIR=#{Formula["molten-vk"].opt_include}
        -DVulkan_LIBRARY=#{Formula["molten-vk"].opt_lib/shared_library("libMoltenVK")}
      ]
    end

    inreplace "src/gpu.cpp", "glslang/glslang", "glslang"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ncnn/mat.h>

      int main(void) {
          ncnn::Mat myMat = ncnn::Mat(500, 500);
          myMat.fill(1);
          ncnn::Mat myMatClone = myMat.clone();
          myMat.release();
          myMatClone.release();
          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
                    "-I#{Formula["vulkan-headers"].opt_include}", "-I#{include}", "-L#{lib}", "-lncnn",
                    "-o", "test"
    system "./test"
  end
end
