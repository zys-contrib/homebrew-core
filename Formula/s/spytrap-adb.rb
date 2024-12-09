class SpytrapAdb < Formula
  desc "Test a phone for stalkerware and suspicious configuration using usb debugging"
  homepage "https://github.com/spytrap-org/spytrap-adb"
  url "https://github.com/spytrap-org/spytrap-adb/releases/download/v0.3.3/spytrap-adb-0.3.3.tar.gz"
  sha256 "440182e5387085b5ef3635b1d167bd4e3b238961398ef855cef6bfc84a51d41a"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"spytrap-adb", "completions")
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    system bin/"spytrap-adb", "download-ioc"
  end
end
