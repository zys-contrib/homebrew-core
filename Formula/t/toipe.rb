class Toipe < Formula
  desc "Yet another typing test, but crab flavoured"
  homepage "https://github.com/Samyak2/toipe"
  url "https://github.com/Samyak2/toipe/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "31e4c7679487425254ad90bbc4d14a9bd55af6c6a20cce0b3f8eaa52fffe6bf7"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    PTY.spawn(bin/"toipe") do |r, _w, pid|
      output = r.gets
      assert_match "ToipeError: Terminal height is too short! Toipe requires at least 34 lines", output
    ensure
      Process.kill("TERM", pid)
    end

    assert_match version.to_s, shell_output("#{bin}/toipe --version")
  end
end
