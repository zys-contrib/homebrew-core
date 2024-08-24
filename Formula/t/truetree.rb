class Truetree < Formula
  desc "Command-line tool for pstree-like output on macOS"
  homepage "https://themittenmac.com/the-truetree-concept/"
  url "https://github.com/themittenmac/TrueTree/archive/refs/tags/V0.8.tar.gz"
  sha256 "38a6c3fa7328db16fdb66315ca97feb6cbbfb0a53d8af5aabd97e6d6a498a2c7"
  license "CC-BY-NC-4.0"

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "build"
    sbin.install "build/Release/TrueTree"
  end

  def caveats
    <<~EOS
      TrueTree requires root privileges so you will need to run `sudo #{HOMEBREW_PREFIX}/sbin/TrueTree`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    output = pipe_output("#{sbin}/TrueTree")
    assert_match "This tool must be run as root", output
  end
end
