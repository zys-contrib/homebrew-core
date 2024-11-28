class Rogcat < Formula
  desc "Adb logcat wrapper"
  homepage "https://github.com/flxo/rogcat"
  url "https://github.com/flxo/rogcat/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8b4d90dd1254ff82bc01cadcb8a157dc4d66d2e987471ae3c3eaa99f03e34ba3"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rogcat", "completions")
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    output = shell_output("#{bin}/rogcat devices 2>&1", 101)
    assert_match "Failed to find adb", output

    assert_match version.to_s, shell_output("#{bin}/rogcat --version")
  end
end
