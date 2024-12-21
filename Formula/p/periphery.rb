class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/2.21.2.tar.gz"
  sha256 "97e399df17d1e681703c5c8852e50b40c056a98b41dc4c615011c048b8348dbb"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  uses_from_macos "swift" => [:build, :test], since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "periphery"
    bin.install ".build/release/periphery"
  end

  test do
    # Periphery dynamically loads 'libIndexStore' at runtime and must find its location depending on the host OS.
    # On macOS, the library is bundled within Xcode at a consistent location. On Linux, the library path is assumed
    # to be at 'lib/libIndexStore.so' relative to the path of the 'swift' binary, which is a reasonable assumption for
    # most installations. However, this is not the case on the Homebrew Linux test container, and the shared libraries
    # do not appear to be present.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "swift", "package", "init", "--name", "test", "--type", "executable"
    system "swift", "build", "--disable-sandbox"
    manifest = shell_output "swift package --disable-sandbox describe --type json"
    File.write "manifest.json", manifest
    system bin/"periphery", "scan", "--strict", "--skip-build", "--json-package-manifest-path", "manifest.json"
  end
end
