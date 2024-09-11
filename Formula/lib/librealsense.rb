class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.56.1.tar.gz"
  sha256 "cba681c9ff231898ee768bb39d5e5a7bd564289230ca178ae2866ee40f2a3ae9"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "536ba8013937196624647d0ba9644259522d8b3f37f3064fbfe0d5dcdaac8005"
    sha256 cellar: :any,                 arm64_ventura:  "643b698a1cdb56090216f33ce4e3d3f4e6ff4bc8b96caf3f46a9f91c49190f19"
    sha256 cellar: :any,                 arm64_monterey: "2e37c17545c842bdb9700fdd462348adf81fafb6ccb398d5a1753d0adae3d7a5"
    sha256 cellar: :any,                 sonoma:         "93c595644a491d8e1cb3f4fd13319fcbeb92f83f60ff811907a15416958a437e"
    sha256 cellar: :any,                 ventura:        "0d266810de67660e2ceea74de1b095a30e45a3d24b340c74dbc731ab1ebe15c3"
    sha256 cellar: :any,                 monterey:       "b34fdb72b7d52132ef87929d646e29433f34f5ed091edf20e008c6579e4675db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac83b06d249292aa468c151b5857ee774dc01ad206c6686cd93c6ebc0b0977dc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "libusb"
  depends_on "openssl@3"
  # Build on Apple Silicon fails when generating Unix Makefiles.
  # Ref: https://github.com/IntelRealSense/librealsense/issues/8090
  on_arm do
    depends_on xcode: :build
  end

  def install
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].prefix

    args = %W[
      -DENABLE_CCACHE=OFF
      -DBUILD_WITH_OPENMP=OFF
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    if Hardware::CPU.arm?
      args << "-DCMAKE_CONFIGURATION_TYPES=Release"
      args << "-GXcode"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense2/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
