class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://github.com/Slackadays/Clipboard/archive/refs/tags/0.10.0.tar.gz"
  sha256 "741717ee505a7852fab5c69740b019e2b33f81d948232894ce294ed0a55e70fb"
  license "GPL-3.0-or-later"
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8501c5412bdafe9871e98abcf6a8ac74ea21ef54d4824585688725319689310d"
    sha256 cellar: :any,                 arm64_sonoma:  "43da80ae657f14a03ed778237fa36b638555a66e1711c93adb5e201ea1c932c8"
    sha256 cellar: :any,                 arm64_ventura: "0b0573a91397eb893042a7496a057ef63545e5b843d34c85ee68edf89fcd22b2"
    sha256 cellar: :any,                 sonoma:        "e2dda12c223d91e437af9d40332bb1e4ece529aa0635710ec6b9ad3b3deae428"
    sha256 cellar: :any,                 ventura:       "75b250a323dba0e3f489e13261b1743ee9d800f248ad8f5c548a5ea0b697fb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7e1298b4b0428e8eefe474d18815cdf6b534068da2a7b8e04624cd2d58baeee"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "wayland-protocols" => :build
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "wayland"
  end

  fails_with :clang do
    build 1300
    cause "Requires C++20 support"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    # `-Os` is slow and buggy.
    #   https://github.com/Homebrew/homebrew-core/issues/136551
    #   https://github.com/Slackadays/Clipboard/issues/147
    ENV.O3

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CLIPBOARD_FORCETTY"] = "1"
    ENV["CLIPBOARD_NOGUI"] = "1"
    system bin/"cb", "copy", test_fixtures("test.png")
    system bin/"cb", "paste"
    assert_predicate testpath/"test.png", :exist?
  end
end
