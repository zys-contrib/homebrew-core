class Walk < Formula
  desc "Terminal navigator"
  homepage "https://github.com/antonmedv/walk"
  url "https://github.com/antonmedv/walk/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "76e8db66942af53447f5ab3f0aaec49b539a68714130e46c83a01fff9c00438f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "732e36ba368d5717b5fa554a5d32ce51a256b87e2f8a17112b7bed46d9cad0b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "732e36ba368d5717b5fa554a5d32ce51a256b87e2f8a17112b7bed46d9cad0b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "732e36ba368d5717b5fa554a5d32ce51a256b87e2f8a17112b7bed46d9cad0b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b4e9337d4b3d9675f0571a3d014cd3045e62d6a933e4ce3e8678b757dead1ca"
    sha256 cellar: :any_skip_relocation, ventura:        "1b4e9337d4b3d9675f0571a3d014cd3045e62d6a933e4ce3e8678b757dead1ca"
    sha256 cellar: :any_skip_relocation, monterey:       "1b4e9337d4b3d9675f0571a3d014cd3045e62d6a933e4ce3e8678b757dead1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6a5aee8aad4db1489d5ae1b96673b68cc330f7c0d1cac3a8f042d08878b037d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"

    PTY.spawn(bin/"walk") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
