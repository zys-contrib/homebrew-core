class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https://github.com/leg100/pug"
  url "https://github.com/leg100/pug/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "3979b5f95690f8def808ed49f6e1c7ea9ccce7e7d2f9d194c5ed3e7c8a36ca83"
  license "MPL-2.0"
  head "https://github.com/leg100/pug.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/leg100/pug/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _w, pid = PTY.spawn("#{bin}/pug --debug")
    # check on TUI elements
    assert_match "Modules", r.readline
    # check on debug logs
    assert_match "loaded 0 modules", (testpath/"messages.log").read

    assert_match version.to_s, shell_output("#{bin}/pug --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
