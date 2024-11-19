class Mupen64plus < Formula
  desc "Cross-platform plugin-based N64 emulator"
  homepage "https://www.mupen64plus.org/"
  url "https://github.com/mupen64plus/mupen64plus-core/releases/download/2.6.0/mupen64plus-bundle-src-2.6.0.tar.gz"
  sha256 "297e17180cd76a7b8ea809d1a1be2c98ed5c7352dc716965a80deb598b21e131"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 sonoma:       "c230208074feda97c361199781940d50f7918419802ec903eec833d3ff2c0af0"
    sha256 ventura:      "2c6365b16dbb1c3e70acd5068dfeab479f0742d8c9ae8df40df40af5524b119d"
    sha256 monterey:     "81ce3aecfc6b2f110322459cbdde89176590fe8e445d75ca7136dfec520c7f4d"
    sha256 x86_64_linux: "e4140dea7a57faf9c5f5adcd2a5b8803f7e19ba989c7f375c73d84a2d3459010"
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "vulkan-loader"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  # Backport fix to avoid macOS app bundle path
  patch do
    url "https://github.com/mupen64plus/mupen64plus-ui-console/commit/1cab2e6dfe46d5fbc4c23e1e7fbb4502a4e57981.patch?full_index=1"
    sha256 "a6e80f36b65406d31f3611f88e695e5c079db52b6f68daa8eb01307f5447194c"
    directory "source/mupen64plus-ui-console"
  end

  def install
    # Prevent different C++ standard library warning
    if OS.mac?
      inreplace Dir["source/mupen64plus-*/projects/unix/Makefile"],
                /(-mmacosx-version-min)=\d+\.\d+/,
                "\\1=#{MacOS.version}"
    end

    args = ["PREFIX=#{prefix}", "SHAREDIR=#{pkgshare}", "NO_SRC=1", "NO_SPEEX=1", "V=1"]
    args << "USE_GLES=1" if OS.linux?

    system "./m64p_build.sh", *args
    system "./m64p_install.sh", *args
  end

  test do
    # Disable test in Linux CI because it hangs because a display is not available.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    resource "rom" do
      url "https://github.com/mupen64plus/mupen64plus-rom/raw/76ef14c876ed036284154444c7bdc29d19381acc/m64p_test_rom.v64"
      sha256 "b5fe9d650a67091c97838386f5102ad94c79232240f9c5bcc72334097d76224c"
    end

    resource("rom").stage do
      system bin/"mupen64plus", "--testshots", "1", "m64p_test_rom.v64"
    end
  end
end
