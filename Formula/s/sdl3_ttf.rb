class Sdl3Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://github.com/libsdl-org/SDL_ttf"
  url "https://github.com/libsdl-org/SDL_ttf/releases/download/release-3.2.0/SDL3_ttf-3.2.0.tar.gz"
  sha256 "9a741defb7c7d6dff658d402cb1cc46c1409a20df00949e1572eb9043102eb62"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_ttf.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "sdl3"

  uses_from_macos "perl" => :build

  def install
    system "cmake", "-S", ".",
                    "-B", "build",
                    "-DSDLTTF_PLUTOSVG=OFF",
                    "-DSDLTTF_INSTALL_MAN=ON",
                    "-DSDLTTF_STRICT=ON",
                    "-DSDLTFF_VENDORED=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL3_ttf/SDL_ttf.h>
      #include <stdlib.h>

      int main() {
        return TTF_Version() == SDL_TTF_VERSION ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
    system ENV.cc, "test.c", "-I#{Formula["sdl3"].opt_include}", "-L#{lib}", "-lSDL3_ttf", "-o", "test"
    system "./test"
  end
end
