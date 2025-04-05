class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.21",
      revision: "ea5f02a87af0942ee8af4cd2fdda01a95495aafe"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3d7be0481dc7f68bf48cadc426910773ef6358819654ee8976b48007f76969c1"
    sha256 cellar: :any, arm64_sonoma:  "407dd50764631d508a4fec2f22894b3d6837496498680e80f6a4c92b2fec5deb"
    sha256 cellar: :any, arm64_ventura: "4f80d98a1b7a40ddb3289e70b9d70b56caf52a6a05c20b903444d2865eb1ff5a"
    sha256 cellar: :any, sonoma:        "52e99cca0287d7e88696fe5209d5272d2b16f187cd8bf729c3a133e210b5c87a"
    sha256 cellar: :any, ventura:       "018561814658f374c1f423df99168abe8762f3c406195c7d6ae78a775d35077b"
    sha256               arm64_linux:   "777bde65cccfea3e05c828561ddffa79acf124bb387fbca9720370154ba9545d"
    sha256               x86_64_linux:  "16d529dd1728164ba6be80b31b7ee896a4daba7bae646e67b563bfdf511eff72"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build

  depends_on "duktape"
  depends_on "flac"
  depends_on "freetype"
  depends_on "icu4c@77"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on macos: :sonoma # Needs C++20 features not in Ventura
  depends_on "openssl@3"
  depends_on "sdl2"
  depends_on "speexdsp"

  uses_from_macos "zlib"

  on_linux do
    depends_on "curl"
    depends_on "fontconfig"
    depends_on "mesa"
  end

  resource "title-sequences" do
    url "https://github.com/OpenRCT2/title-sequences/releases/download/v0.4.14/title-sequences.zip"
    sha256 "140df714e806fed411cc49763e7f16b0fcf2a487a57001d1e50fce8f9148a9f3"
  end

  resource "objects" do
    url "https://github.com/OpenRCT2/objects/releases/download/v1.6.1/objects.zip"
    sha256 "6829186630e52c332b6a4847ebb936c549a522fcadaf8f5e5e4579c4c91a4450"
  end

  resource "openmusic" do
    url "https://github.com/OpenRCT2/OpenMusic/releases/download/v1.6/openmusic.zip"
    sha256 "f097d3a4ccd39f7546f97db3ecb1b8be73648f53b7a7595b86cccbdc1a7557e4"
  end

  resource "opensound" do
    url "https://github.com/OpenRCT2/OpenSoundEffects/releases/download/v1.0.5/opensound.zip"
    sha256 "a952148be164c128e4fd3aea96822e5f051edd9a0b1f2c84de7f7628ce3b2e18"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/sequence").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")
    resource("openmusic").stage do
      (buildpath/"data/assetpack").install Dir["assetpack/*"]
      (buildpath/"data/object/official").install "object/official/music"
    end
    resource("opensound").stage do
      (buildpath/"data/assetpack").install Dir["assetpack/*"]
      (buildpath/"data/object/official").install "object/official/audio"
    end

    args = %w[
      -DWITH_TESTS=OFF
      -DDOWNLOAD_TITLE_SEQUENCES=OFF
      -DDOWNLOAD_OBJECTS=OFF
      -DDOWNLOAD_OPENMSX=OFF
      -DDOWNLOAD_OPENSFX=OFF
      -DMACOS_USE_DEPENDENCIES=OFF
      -DDISABLE_DISCORD_RPC=ON
    ]
    args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # By default, the macOS build only looks for data in app bundle Resources.
    libexec.install bin/"openrct2"
    (bin/"openrct2").write <<~BASH
      #!/bin/bash
      exec "#{libexec}/openrct2" "$@" "--openrct2-data-path=#{pkgshare}"
    BASH
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}/openrct2 -v")
  end
end
