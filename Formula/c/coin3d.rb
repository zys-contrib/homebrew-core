class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin)"
  homepage "https://coin3d.github.io/"
  license "BSD-3-Clause"
  revision 2

  stable do
    url "https://github.com/coin3d/coin/releases/download/v4.0.3/coin-4.0.3-src.tar.gz"
    sha256 "66e3f381401f98d789154eb00b2996984da95bc401ee69cc77d2a72ed86dfda8"

    resource "soqt" do
      url "https://github.com/coin3d/soqt/releases/download/v1.6.3/soqt-1.6.3-src.tar.gz"
      sha256 "79342e89290783457c075fb6a60088aad4a48ea072ede06fdf01985075ef46bd"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "788e8af8f7eef2baecbe637c9b749b0bbb3374cac3480ea4ebbbf98f5ea0d24c"
    sha256 cellar: :any,                 arm64_ventura: "5ff987acf7ede22752c4d4b193d4ec8f63a9f402737eb8078d675e1a0db8b2fd"
    sha256 cellar: :any,                 sonoma:        "af3184b755a9830954954132172e9f911df140e598a02c2b8c5d7cf6b7081370"
    sha256 cellar: :any,                 ventura:       "8ff9c323ded49fc7207e7802e7fdb952867ee494ba56bc33bf5a30b73af5c0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a099ddb5fad2794a8c8591fb702c3ec710b9773c8969d08c17e9ef3d2f5b516"
  end

  head do
    url "https://github.com/coin3d/coin.git", branch: "master"

    resource "soqt" do
      url "https://github.com/coin3d/soqt.git", branch: "master"
    end
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "qt"

  uses_from_macos "expat"

  on_linux do
    depends_on "libx11"
    depends_on "libxi"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def python3
    "python3.13"
  end

  def install
    system "cmake", "-S", ".", "-B", "_build",
                    "-DCOIN_BUILD_MAC_FRAMEWORK=OFF",
                    "-DCOIN_BUILD_DOCUMENTATION=ON",
                    "-DCOIN_BUILD_TESTS=OFF",
                    "-DUSE_EXTERNAL_EXPAT=ON",
                    *std_cmake_args(find_framework: "FIRST")
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    resource("soqt").stage do
      system "cmake", "-S", ".", "-B", "_build",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      "-DSOQT_BUILD_MAC_FRAMEWORK=OFF",
                      "-DSOQT_BUILD_DOCUMENTATION=OFF",
                      "-DSOQT_BUILD_TESTS=OFF",
                      *std_cmake_args(find_framework: "FIRST")
      system "cmake", "--build", "_build"
      system "cmake", "--install", "_build"
    end
  end

  def caveats
    "The Python bindings (Pivy) are now in the `pivy` formula."
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <Inventor/SoDB.h>
      int main() {
        SoDB::init();
        SoDB::cleanup();
        return 0;
      }
    CPP

    opengl_flags = if OS.mac?
      ["-Wl,-framework,OpenGL"]
    else
      ["-L#{Formula["mesa"].opt_lib}", "-lGL"]
    end

    system ENV.cc, "test.cpp", "-L#{lib}", "-lCoin", *opengl_flags, "-o", "test"
    system "./test"
  end
end
