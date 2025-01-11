class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "11395"
  version "124.2.2"
  license "Artistic-1.0"
  revision 2
  head "https://github.com/simutrans/simutrans.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    regex(%r{href=.*?/files/simutrans/(\d+(?:[.-]\d+)+)/}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1870bef6a3696e5b35fb4e3a8d903c421e56a667e4d7ec6ae395f56dbe7b9055"
    sha256 cellar: :any,                 arm64_sonoma:  "fff46dc0129cdf44071ad4d7b0b02caa3945969d1230a7d05b9a42fbb01d772c"
    sha256 cellar: :any,                 arm64_ventura: "357060ba4392123bfc2630ca5a1da7b05d40b6099078f17c2b68405a03fe4cd1"
    sha256 cellar: :any,                 sonoma:        "31fcf35b0a660d9e900dd608be3d5809bbd1a41427ffec780f909eaebe092c1a"
    sha256 cellar: :any,                 ventura:       "3eb5cef974fa09a363ee9298a775c59757f5483da9a99e98f945f005fbb16eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "358008f6fb7e7e16f1b4f0ee7224fb8936ca99f19ffcf62cc32b01fb1f4c3c0c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "miniupnpc"
  depends_on "sdl2"
  depends_on "zstd"

  uses_from_macos "unzip" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/124-2/simupak64-124-2.zip"
    sha256 "e690e4647a1a617032a3778a2457c8812cc4510afad0f5bf8524999468146d86"
  end
  resource "soundfont" do
    url "https://src.fedoraproject.org/repo/pkgs/PersonalCopy-Lite-soundfont/PCLite.sf2/629732b7552c12a8fae5b046d306273a/PCLite.sf2"
    sha256 "ba3304ec0980e07f5a9de2cfad3e45763630cbc15c7e958c32ce06aa9aefd375"
  end

  def install
    # These translations are dynamically generated.
    system "./tools/get_lang_files.sh"

    system "cmake", "-B", "build", "-S", ".", "-DSIMUTRANS_USE_REVISION=#{stable.specs[:revision]}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "makeobj"
    system "cmake", "--build", "build", "--target", "nettool"

    simutrans_path = OS.mac? ? "simutrans/simutrans.app/Contents/MacOS" : "simutrans"
    libexec.install "build/#{simutrans_path}/simutrans" => "simutrans"
    libexec.install Dir["simutrans/*"]
    bin.write_exec_script libexec/"simutrans"
    bin.install "build/src/makeobj/makeobj"
    bin.install "build/src/nettool/nettool"

    libexec.install resource("pak64")
    (libexec/"music").install resource("soundfont")
  end

  test do
    system bin/"simutrans", "--help"
  end
end
