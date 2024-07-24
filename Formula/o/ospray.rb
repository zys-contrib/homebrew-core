class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "2c8108df2950bc5d1bc2a62f74629233dbe4f36e3f6a8ea032907d4a3fdc6750"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5579d8382f75e7326ad0a8937f6562ff167c1ae1d4650a092610fedab1b4f486"
    sha256 cellar: :any,                 arm64_ventura:  "daed769741e22bd69913fe1d0a726413fcb674616abf57f59700bdf6f8bfeedd"
    sha256 cellar: :any,                 arm64_monterey: "9251be35bf7ca53c4611112bfe41fd2fa714084f7d9dc649d4967c3621a5f057"
    sha256 cellar: :any,                 sonoma:         "d7a76240bab1306d4379cdb7cd38b6d2fd37a96795d182868b2e90d8d91f5417"
    sha256 cellar: :any,                 ventura:        "e1eef957f20f5c977fa7ee8a6f348eb715019f8423cdf9618ecfb5161af151b1"
    sha256 cellar: :any,                 monterey:       "77198703201d64fb1681d9475f7107c7908ed9a87ae7eebe7546483aae6b32e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77698d5997a11ec80305915acbca696811ca3c9305320c5b7986d9de1ce6c02e"
  end

  depends_on "cmake" => :build
  depends_on "embree"
  depends_on "ispc"
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/refs/tags/v1.14.0.tar.gz"
    sha256 "5aef75afc8d4fccf9e70df4cbdf29a1b28b39ee51b5588b94b83a14c6a166d83"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/refs/tags/v2.0.1.tar.gz"
    sha256 "0c7faa9582a93e93767afdb15a6c9c9ba154af7ee83a6b553705797be5f8af62"
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      ENV.remove "HOMEBREW_LIBRARY_PATHS",
                 Formula["ispc"].deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }.opt_lib
    end

    resources.each do |r|
      r.stage do
        args = %W[
          -DCMAKE_INSTALL_NAME_DIR=#{lib}
          -DBUILD_EXAMPLES=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
    end

    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DOSPRAY_ENABLE_APPS=OFF
      -DOSPRAY_ENABLE_TESTING=OFF
      -DOSPRAY_ENABLE_TUTORIALS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <ospray/ospray.h>
      int main(int argc, const char **argv) {
        OSPError error = ospInit(&argc, argv);
        assert(error == OSP_NO_ERROR);
        ospShutdown();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lospray"
    system "./a.out"
  end
end
