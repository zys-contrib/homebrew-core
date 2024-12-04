class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.22.2.tar.gz"
  sha256 "1aaa75c441e53c5a0bd9917ee996e0eb471032c8a217e2c276f6b7a65f987eb9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f7b7da2e9561335911f258319047cdab5a5bdbafec6420eee1bd1c94d4a57ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f7b7da2e9561335911f258319047cdab5a5bdbafec6420eee1bd1c94d4a57ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f7b7da2e9561335911f258319047cdab5a5bdbafec6420eee1bd1c94d4a57ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "d646624b239ab115cbf728ed62eb2e50bcf6bd068b5d5dcfa54293f606e8c957"
    sha256 cellar: :any_skip_relocation, ventura:       "d646624b239ab115cbf728ed62eb2e50bcf6bd068b5d5dcfa54293f606e8c957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c21579737f22b11e72f818024a3ae0d0d3cb515509dbe9f369c0800e371734f2"
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
