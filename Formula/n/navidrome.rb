class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "4ba97d7760964da600383820af644176d9a44f6e0eee7de5989afb6be2b78730"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ab07cedd93d3134ec01d629757ed998b5cb358d57b08f68a4af5ebe32595ef2"
    sha256 cellar: :any,                 arm64_sonoma:  "69a5089cba2cc8b6fb0703ededa6d0a7d2845254f56b47b3317114e12ea95b8b"
    sha256 cellar: :any,                 arm64_ventura: "f5780993b99fe396317570703b4071333f5608d4f854d7f49e60bc0630016960"
    sha256 cellar: :any,                 sonoma:        "963db76b8a470cd941c28f910da458178804b61bfe2b4d72057a85613f504b82"
    sha256 cellar: :any,                 ventura:       "787ff009c0e621810f295404713a3047de39bcee7442adaf371808c1fe748d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "569507e612fae8b2f5f3093d345cdc1f8829e3d902ca5749a737327d1f0209bc"
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
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "-buildvcs=false"
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
