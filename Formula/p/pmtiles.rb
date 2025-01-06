class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "87cb1db2be4429bc0d5f4bb5de3301a00a3fd9034299b253d5825cb66cd63fb7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c5a39e65f0b7e8bd6debdad90c4864d271e040267a0f3b817dcba9f4b46c1d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c5a39e65f0b7e8bd6debdad90c4864d271e040267a0f3b817dcba9f4b46c1d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c5a39e65f0b7e8bd6debdad90c4864d271e040267a0f3b817dcba9f4b46c1d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c66ef7e4f6fe6d2d911432ba493482820fa1f404271be25c84ed2dd598cca56"
    sha256 cellar: :any_skip_relocation, ventura:       "4c66ef7e4f6fe6d2d911432ba493482820fa1f404271be25c84ed2dd598cca56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280d4164a8b17569bedaa810da45747a23754ac11ceb81a9097c90a7c1dde091"
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
