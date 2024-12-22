class Angband < Formula
  desc "Dungeon exploration game"
  homepage "https://rephial.org/"
  url "https://github.com/angband/angband/releases/download/4.2.5/Angband-4.2.5.tar.gz"
  sha256 "c4cacbdf28f726fcb1a0b30b8763100fb06f88dbb570e955232e41d83e0718a6"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "017176e2d06d6cd9e427b88abc73538316ff03a406b7587ad9cc13fd3eed1257"
    sha256 arm64_sonoma:   "d37403044024a99c1f59d8df1d0c87ff6d05c4ec8c17fb4d709531e26b60c85e"
    sha256 arm64_ventura:  "c7501052965e907fd7a088f4e5fbe06c0a89f7064f96965bbe6f1637cb83387d"
    sha256 arm64_monterey: "2e614515be3541395fcc42067c4e5174157c51a27d35645cd6798be7d0a45f83"
    sha256 arm64_big_sur:  "4ebb2cc5ce335cc1760a5225733a8dd55594d332be9330fa60d8d7877c34732e"
    sha256 sonoma:         "158100f85942987f4f31ca4c441c804c71ef0e8acc673bc8215931591289bfad"
    sha256 ventura:        "808d10e9cc163ef98847717e263ed262228d53cc2034b17c8a7510e8feb3992d"
    sha256 monterey:       "b99c56e6324749ead8f874ef8b1c9a795042190849f0d3a21be96eca60558fe0"
    sha256 big_sur:        "f96fbff60ba98dbdb462fdca56ee7b4891737afc7cc90451432cafc8a727d516"
    sha256 x86_64_linux:   "cdf766e08ed71a08dab5b873333ef14bb4ed7918a55601a35106b4dbb717538f"
  end

  head do
    url "https://github.com/angband/angband.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  on_system :linux, macos: :sonoma_or_newer do
    depends_on "ncurses" # ncurse5.4-config is broken on recent macOS
  end

  def install
    args = %W[
      --bindir=#{bin}
      --enable-release
      --enable-curses
      --disable-ncursestest
      --disable-sdltest
      --disable-x11
    ]
    if OS.mac? && MacOS.version < :sonoma
      ENV["NCURSES_CONFIG"] = "#{MacOS.sdk_path}/usr/bin/ncurses5.4-config"
      args << "--with-ncurses-prefix=#{MacOS.sdk_path}/usr"
    end
    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    require "expect"
    require "pty"

    timeout = 10
    args = %W[
      -duser=#{testpath}
      -darchive=#{testpath}/archive
      -dpanic=#{testpath}/panic
      -dsave=#{testpath}/save
      -dscores=#{testpath}/scores
    ]

    PTY.spawn({ "LC_ALL" => "en_US.UTF-8", "TERM" => "xterm" }, bin/"angband", *args) do |r, w, pid|
      refute_nil r.expect("[Initialization complete]", timeout), "Expected initialization message"
      w.write "\x18"
      refute_nil r.expect("Please select your character", timeout), "Expected character selection"
      w.write "\x18"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
  end
end
