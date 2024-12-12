class CratesTui < Formula
  desc "TUI for exploring crates.io using Ratatui"
  homepage "https://github.com/ratatui/crates-tui"
  url "https://github.com/ratatui/crates-tui/archive/refs/tags/v0.1.23.tar.gz"
  sha256 "104167275985e2811fa9c64af177bd2616ec6cd1b5a02e931f2afe5c6c29a191"
  license "MIT"
  head "https://github.com/ratatui/crates-tui.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crates-tui --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"crates-tui", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "New Crates", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
