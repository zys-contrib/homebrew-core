class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "082c152e31fb0c0f0adfa60780480d756c4589649963b6616599ab696b7989b4"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output(bin/"oxker --host 2>&1", 2)
  end
end
