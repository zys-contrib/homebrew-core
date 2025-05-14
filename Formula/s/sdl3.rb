class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.2.14/SDL3-3.2.14.tar.gz"
  sha256 "b7e7dc05011b88c69170fe18935487b2559276955e49113f8c1b6b72c9b79c1f"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1664282106f49f93bfe743993014977d93a67004dc70867eb2afefa182350add"
    sha256 cellar: :any,                 arm64_sonoma:  "4b6a436b7c21060c3dd37e4d14aa8305d3338fe2217fa91d50e1dee3e6781eb3"
    sha256 cellar: :any,                 arm64_ventura: "45ce909d24806f4b7b1e62e2d6e6b87f813ee2de08bee56b9c3e579aaaed107d"
    sha256 cellar: :any,                 sonoma:        "dffa13e72cb706c3aa8ab3a408c9133afc4ec72b6c423dbb6dbaa0069e64809b"
    sha256 cellar: :any,                 ventura:       "6d99b4276447d5f4ebf88f87f5b59d14a9581c0d757e70c7017a47db0a9762d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d17458e4c432a49f72c44a2d4bc039fa314caf0edb388cee4cee9cf75fcd9729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a24213bb34c83ac130fab7b3fbd3c626bdacbef49250833a9156ca46797633bc"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libice"
    depends_on "libxcursor"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "pulseaudio"
    depends_on "xinput"
  end

  def install
    inreplace "cmake/sdl3.pc.in", "@SDL_PKGCONFIG_PREFIX@", HOMEBREW_PREFIX

    args = [
      "-DSDL_HIDAPI=ON",
      "-DSDL_WAYLAND=OFF",
    ]

    args += if OS.mac?
      ["-DSDL_X11=OFF"]
    else
      ["-DSDL_X11=ON", "-DSDL_PULSEAUDIO=ON"]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~CPP
      #include <SDL3/SDL.h>
      int main() {
        if (SDL_Init(SDL_INIT_VIDEO) != 1) {
          return 1;
        }
        SDL_Quit();
        return 0;
      }
    CPP
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lSDL3", "-o", "test"
    ENV["SDL_VIDEODRIVER"] = "dummy"
    system "./test"
  end
end
