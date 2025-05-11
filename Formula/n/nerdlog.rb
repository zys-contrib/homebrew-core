class Nerdlog < Formula
  desc "TUI log viewer with timeline histogram and no central server"
  homepage "https://dmitryfrank.com/projects/nerdlog/article"
  url "https://github.com/dimonomid/nerdlog/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "5e203df042081f103222c7f09fc1aac70f6ef5804c34d7c0fc3794eb3f2b2868"
  license "BSD-2-Clause"
  head "https://github.com/dimonomid/nerdlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec219169ed96ac12fc190b65bf8daee3a155e560c8294614c513e7dc1f1a58d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10e835b240c0168ce54b9f5a80f1efc13c5db04f6c88a5b6ac8b0b90f8204ee2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ea1b53bd7572f06e77db17c8fe095fba4b170d07594fd1e793b554d3447a69a"
    sha256 cellar: :any_skip_relocation, sonoma:        "78fb88a50c663341fd0d2f5f3ea960e3abc9de83922e373d30efd795aeb4b3bb"
    sha256 cellar: :any_skip_relocation, ventura:       "da7186e9791489f57b740e10a7ecf5fc6f99536ac77ffc046590b0309541444d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66a4ada6105c759e7f43ebe5d221c82aab4e2c26257147490c495d989df91326"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/dimonomid/nerdlog/version.version=#{version}
      -X github.com/dimonomid/nerdlog/version.commit=Homebrew
      -X github.com/dimonomid/nerdlog/version.date=#{time.iso8601}
      -X github.com/dimonomid/nerdlog/version.builtBy=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdlog"
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"nerdlog") do |r, _w, pid|
      sleep 2
      Process.kill("TERM", pid)
      begin
        output = r.read
        assert_match "Edit query params", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match version.to_s, shell_output("#{bin}/nerdlog --version")
  end
end
