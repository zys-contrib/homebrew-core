class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.0.1.tar.gz"
  sha256 "6498ba5bf27b5e0ea76e254538f1c5f9a38b828b26edb9d2e6b46db6c05f91c2"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60b8bcbf4e6d42e7bff450360fc3cf4ec8c49fca3ee24cd158804aa24ce7cb9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81ee58da50e8fbdabe8ec22363ce8e826b3eaac3e39fcfb561ba27194cb605bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "68af69cfa1483a7cd3eecb92c6eedb30743b3911d86dc02fb501d3d42c6011be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b873ed835db7aab36f8bc7a4146fe2c9ad61978336e201209f768cb159ab9fa"
  end

  depends_on xcode: ["15.4", :build]

  uses_from_macos "swift" => [:build, :test]
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
