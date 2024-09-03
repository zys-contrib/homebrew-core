class Wush < Formula
  desc "Transfer files between computers via WireGuard"
  homepage "https://github.com/coder/wush"
  url "https://github.com/coder/wush/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8e1ffd24b51775ac68116b381cf4523a54d4e7742e440b7d279418faa52904eb"
  license "CC0-1.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/wush"
  end

  test do
    read, write = IO.pipe

    pid = fork do
      exec bin/"wush", "serve", out: write
    end

    output = read.gets
    assert_includes output, "Picked DERP region"
    output = read.gets
    assert_includes output, "Your auth key is:"
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
