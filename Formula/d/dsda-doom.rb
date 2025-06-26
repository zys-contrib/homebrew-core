class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "4ffb93a1f602fa0bf5ecad987eef52c0735035132f9b999111cf709d40a939b7"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "8e0be803f4ce526841a577548cc311a8ac0c23b77f8ba56a4845aa84cedb9ebf"
    sha256 arm64_sonoma:  "7be70c4425c3f279829e0df0d917774eef23e984967f461cdfb07fb5ac0778de"
    sha256 arm64_ventura: "0403fc0d20145a048cb9c5fd0f70d518518a13e82e6d3df0a827e11e6d3092f5"
    sha256 sonoma:        "4374e90d7cdd3e119ff841fe2e320ba416080e11e3d6a7016e6201d23d5299fd"
    sha256 ventura:       "644b5ca52abcc76985aa8bdfbfde9b67d27d482fc44b6c2bdedce704359d3854"
    sha256 arm64_linux:   "1b77fe855c83dbbf7c53d61c7423316884e0d7262105d24f2ae67a4a32e0ee9b"
    sha256 x86_64_linux:  "e2cdb71a61e28ca7265d6c5b21830f28b0fcaeddf5688edbbb6891c4ba1e1a76"
  end

  depends_on "cmake" => :build

  depends_on "dumb"
  depends_on "fluid-synth"
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
                    "-DWITH_DUMB=OM",
                    "-DWITH_FLUIDSYNTH=ON",
                    "-DWITH_IMAGE=ON",
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
