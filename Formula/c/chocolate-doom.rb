class ChocolateDoom < Formula
  desc "Accurate source port of Doom"
  homepage "https://www.chocolate-doom.org/"
  url "https://github.com/chocolate-doom/chocolate-doom/archive/refs/tags/chocolate-doom-3.1.0.tar.gz"
  sha256 "f2c64843dcec312032b180c3b2f34b4cb26c4dcdaa7375a1601a3b1df11ef84d"
  license "GPL-2.0-only"
  head "https://github.com/chocolate-doom/chocolate-doom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6dac150b1bd767f58c260e3689d4446b257de60038a55cb72caf8e7c7caa7ef8"
    sha256 cellar: :any,                 arm64_ventura:  "8e670f4a512697c01cf64c4b6f12bf10dd512241b18b6901d60cfb545d7c755c"
    sha256 cellar: :any,                 arm64_monterey: "413b538d84ce6683c965c9a996da15ce4a6217bcdc950761164bae1355bd9ad2"
    sha256 cellar: :any,                 arm64_big_sur:  "2ec976b70085d5774860143fa03bc8c46493383faf512c61eba9eb0ab3985942"
    sha256 cellar: :any,                 sonoma:         "df26721adf0f26a8cc4533d7b358ab44c7c028c2d45f0c8f506bd6bbcec6aadf"
    sha256 cellar: :any,                 ventura:        "6a82c853bac7bf16dc7e2d54ff79a4806e4ceb6a84a6292450aff548e2afd8d3"
    sha256 cellar: :any,                 monterey:       "c038f08c989b156b389d9f74518bda94b8c054807392abc4673a43a297772f77"
    sha256 cellar: :any,                 big_sur:        "229f40caf921ce47bf5683f360473a783f281d2261be52758804c5203bc5df1b"
    sha256 cellar: :any,                 catalina:       "91f8a622d0299afd99d6eb4768184100addb0d1a804683aa6486548ed5a14d8d"
    sha256 cellar: :any,                 mojave:         "9090cd83e434977b523647ea125b5de78ca8c2b434f1933a606200999e137a30"
    sha256 cellar: :any,                 high_sierra:    "c4799300dc6c4b10d68e0764cb57eec612fbe3d07a2ce7eeb0cf6bc60905a687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9a256c7ef6e9231057c9cf190bcd1fc8160d5d5b5b11e8efc3ebfef59c78d9d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl2_net"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install", "execgamesdir=#{bin}"
    rm_r(share/"applications")
    rm_r(share/"icons")
  end

  def caveats
    <<~EOS
      Note that this formula only installs a Doom game engine, and no
      actual levels. The original Doom levels are still under copyright,
      so you can copy them over and play them if you already own them.
      Otherwise, there are tons of free levels available online.
      Try starting here:
        #{homepage}
    EOS
  end

  test do
    testdata = <<~EOS
      Invalid IWAD file
    EOS
    (testpath/"test_invalid.wad").write testdata

    expected_output = "Wad file test_invalid.wad doesn't have IWAD or PWAD id"
    assert_match expected_output, shell_output("#{bin}/chocolate-doom -nogui -iwad test_invalid.wad 2>&1", 255)
  end
end
