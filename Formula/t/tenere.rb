class Tenere < Formula
  desc "TUI interface for LLMs written in Rust"
  homepage "https://github.com/pythops/tenere"
  url "https://github.com/pythops/tenere/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "865c9b041faf935545dbb9753b33a8ff09bf4bfd8917d25ca93f5dc0c0cac114"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tenere --version")
    assert_match "Can not find the openai api key", shell_output("#{bin}/tenere 2>&1", 1)
  end
end
