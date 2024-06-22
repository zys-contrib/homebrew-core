class Asak < Formula
  desc "Cross-platform audio recording/playback CLI tool with TUI"
  homepage "https://github.com/chaosprint/asak"
  url "https://github.com/chaosprint/asak/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "e5c7da28f29e4e1e45aa57db4c4ab94278d59bd3bdb717ede7d04f04b1f7ed36"
  license "MIT"
  head "https://github.com/chaosprint/asak.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "jack"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/asak play")
    assert_match "No wav files found in current directory", output

    assert_match version.to_s, shell_output("#{bin}/asak --version")
  end
end
