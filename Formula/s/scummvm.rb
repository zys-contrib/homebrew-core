class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.9.0/scummvm-2.9.0.tar.xz"
  sha256 "d5b33532bd70d247f09127719c670b4b935810f53ebb6b7b6eafacaa5da99452"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "fde8fe1a4ea82c6c45ebe935a424d061020f3fa83018dc07662ce4ca4d4e7d3b"
    sha256 arm64_sonoma:  "18d3ebadf6a8503e0b4f406d2d26c0a93edfe0c8241eb9fd42d973ed70942c52"
    sha256 arm64_ventura: "cd418f2f0a06eebf0c918d18a3b9b6998e516e44bc010cffd56a7300bdc572fc"
    sha256 sonoma:        "4fa0b3cbb71aed9ce25e9855931341bf5b6d7b4bbe88340979e822792c088208"
    sha256 ventura:       "7cdd7593bb231778802fa55ab255251149ea8184ab58aed7c8cd8eb829451a6c"
    sha256 x86_64_linux:  "5ece7329bb96f7a983815379454e8209d338e3ce12b05c729f69ba258d84152a"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libmikmod"
  depends_on "libmpeg2"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "./configure", "--enable-release", "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}", *std_configure_args
    system "make", "install"

    rm_r(share/"pixmaps")
    rm_r(share/"icons")
  end

  test do
    # Use dummy driver to avoid issues with headless CI
    ENV["SDL_VIDEODRIVER"] = "dummy"
    ENV["SDL_AUDIODRIVER"] = "dummy"
    system bin/"scummvm", "-v"
  end
end
