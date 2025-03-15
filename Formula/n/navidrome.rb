class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "721d4509c620aa9094118260a348ea7e58d2a3e9de06a82390c5f0d88b01659e"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c7b07175a67e8a6a2aa2bb03ded78a6b6d5c661c94e5dfaebd3bc708029c1c23"
    sha256 cellar: :any,                 arm64_sonoma:  "3167920dbbbda78da339a4cbdfd2784850c461e137db25c7a1b463a0d4b612da"
    sha256 cellar: :any,                 arm64_ventura: "0c79f92539519aabf93b5cb2a5850b43ef5948980d7b32a22a75e2ce5cfe291c"
    sha256 cellar: :any,                 sonoma:        "6ed7c4b5c5a96c09271c3f9fe4bdb9f470cfaea94537a25de4fbbf3cbe9bbcb4"
    sha256 cellar: :any,                 ventura:       "b484825374fcfb454edb157d6203349c9220195c34d0fe1e534ba6595e18ad4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e45938bf1f352eb076475a1206550a45ed4788609ec688a10c017d78c396647"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    ldflags = %W[
      -s -w
      -X github.com/navidrome/navidrome/consts.gitTag=v#{version}
      -X github.com/navidrome/navidrome/consts.gitSha=source_archive
    ]

    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags:), "-buildvcs=false", "-tags=netgo"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}/navidrome --version").chomp
    port = free_port
    pid = spawn bin/"navidrome", "--port", port.to_s
    sleep 20
    sleep 100 if OS.mac? && Hardware::CPU.intel?
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end
