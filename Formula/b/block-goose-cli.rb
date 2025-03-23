class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "d0fe64347288a08c8b9c594989526b83b734ba8eb867e512cbb0d62b71a38fc3"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")

    output = shell_output("#{bin}/goose agents")
    assert_match "Available agent versions:", output
    assert_match "default", output
  end
end
