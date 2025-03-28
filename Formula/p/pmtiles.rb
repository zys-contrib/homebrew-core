class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "87d26dde4f32d2a58692e2b5f197ec21e643be24bf1f73faa7b8982e23e84d31"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df400984c00b4204127b8f7b6bcf468446e8a61c98dd6f7c9354403e2b0354d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df400984c00b4204127b8f7b6bcf468446e8a61c98dd6f7c9354403e2b0354d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df400984c00b4204127b8f7b6bcf468446e8a61c98dd6f7c9354403e2b0354d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebaebf4cc44241f66f9e976cd1f7e8808665566e74f2d1648d889ae242e0567c"
    sha256 cellar: :any_skip_relocation, ventura:       "ebaebf4cc44241f66f9e976cd1f7e8808665566e74f2d1648d889ae242e0567c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "461d57883c91f0674ceebd8f8663b2300f8cf2676629859be2701931a0c6a342"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port

    pid = fork do
      exec bin/"pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end
