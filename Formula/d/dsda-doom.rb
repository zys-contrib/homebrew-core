class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.29.3.tar.gz"
  sha256 "9b9218d26055d2e2a3b830913cfe52f56b2a6dd4a16720634f0bc5dbe560fb84"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "6e9a8f28b867e056a8b9601ea493bf8193c0afd57db799e7a53507c51cc26d18"
    sha256 arm64_sonoma:  "6285d027051ac300047c50ba814ac87d8e29f1e8b688ded6791cd03fe0cb2ebc"
    sha256 arm64_ventura: "9705f52a1c33473b19ea113819887823d04b48bf3518684ec51a28006bd77da5"
    sha256 sonoma:        "e87d54a8d5bb3336aa0275c8b2103efef53b785bf8f9750a2e532072f113be0c"
    sha256 ventura:       "303f91af41fc76ff132871962ea50fa00b355bb0dc0d61e985e71ce24c73da11"
    sha256 arm64_linux:   "57ae0d2b5a22b813aa4af16f4ecb1530b3f8b713dfca30d251aaf996e06f6271"
    sha256 x86_64_linux:  "af966d4173390da68aaccb607379675b027ebd462e02fd13ec44db535b2d002b"
  end

  depends_on "cmake" => :build

  depends_on "fluid-synth"
  depends_on "libopenmpt"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on "mad"
  depends_on "portmidi"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def doomwaddir(root)
    root/"share/games/doom"
  end

  def install
    system "cmake", "-S", "prboom2", "-B", "build",
                    "-DDOOMWADDIR=#{doomwaddir(HOMEBREW_PREFIX)}",
                    "-DDSDAPWADDIR=#{libexec}",
                    "-DWITH_FLUIDSYNTH=ON",
                    "-DWITH_IMAGE=ON",
                    "-DWITH_LIBOPENMPT=ON",
                    "-DWITH_MAD=ON",
                    "-DWITH_PORTMIDI=ON",
                    "-DWITH_VORBISFILE=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    doomwaddir(HOMEBREW_PREFIX).mkpath
  end

  def caveats
    <<~EOS
      For DSDA-Doom to find your WAD files, place them in:
        #{doomwaddir(HOMEBREW_PREFIX)}
    EOS
  end

  test do
    ENV["HOME"] = testpath
    ENV["XDG_DATA_HOME"] = testpath
    mkdir testpath/"Library/Application Support"

    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end
