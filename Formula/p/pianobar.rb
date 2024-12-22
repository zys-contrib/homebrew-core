class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://6xq.net/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2024.12.21.tar.bz2"
  sha256 "16f4dd2d64da38690946a9670e59bc72a789cf6a323f792e159bb3a39cf4a7f5"
  license "MIT"
  head "https://github.com/PromyLOPh/pianobar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?pianobar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a4715216185de4b73a4a5595733ce0e929fda2991151a04c8ac4c58f2245e8a8"
    sha256 cellar: :any,                 arm64_sonoma:   "dfecf674a95a0dfcdffe9d0faca825d61e4733c4f9cd9b41a2bfa75635209783"
    sha256 cellar: :any,                 arm64_ventura:  "ee7d2deecd2fa234a9c14882d25d2828d061de6f5c8b8bbf338a9b97ae040d4b"
    sha256 cellar: :any,                 arm64_monterey: "6332b45b23dfbd4839745039b7a09150874bee615adba4224407f3e0aa8269e2"
    sha256 cellar: :any,                 sonoma:         "c781c81b0ac0e187fef19df756e1ce51a49ff3aa76c6a208e5300e9d23cca031"
    sha256 cellar: :any,                 ventura:        "770e8282379b54adf9e896a90d8ad8bb79595f550117761c27965a5a521e8157"
    sha256 cellar: :any,                 monterey:       "fe84dfc4bb620a7eae6f8aef7d92b5430349d20cae0fe4aaef0d5a0b6e8afa8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0bb0c852528eea565637f7859abd86792173da3161ea88390b9ddf05638f760"
  end

  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "curl"

  def install
    # Discard Homebrew's CFLAGS as Pianobar reportedly doesn't like them
    ENV["CFLAGS"] = "-O2 -DNDEBUG " +
                    # Or it doesn't build at all
                    "-std=c99 " +
                    # build if we aren't /usr/local'
                    "#{ENV.cppflags} #{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "contrib"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    require "pty"
    PTY.spawn(bin/"pianobar") do |stdout, stdin, _pid|
      stdin.putc "\n"
      assert_match "pianobar (#{version})", stdout.read
    end
  end
end
