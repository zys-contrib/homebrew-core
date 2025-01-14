class Sshx < Formula
  desc "Fast, collaborative live terminal sharing over the web"
  homepage "https://sshx.io"
  url "https://github.com/ekzhang/sshx/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "3bc2abc59be26c9eefaf7fc999aa4a3723d2916414c319fd06555415278acb64"
  license "MIT"

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sshx")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sshx --version")

    begin
      process = IO.popen "#{bin}/sshx --quiet"
      sleep 1
      Process.kill "TERM", process.pid
      assert_match "https://sshx.io/s/", process.read
    ensure
      Process.wait process.pid
    end
  end
end
