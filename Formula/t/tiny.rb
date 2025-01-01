class Tiny < Formula
  desc "Terminal IRC client"
  homepage "https://github.com/osa1/tiny"
  url "https://github.com/osa1/tiny/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "599697fa736d7500b093566a32204691093bd16abd76f43a76b761487a7c584c"
  license "MIT"
  head "https://github.com/osa1/tiny.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tiny")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tiny --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tiny", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "tiny couldn't find a config file", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
