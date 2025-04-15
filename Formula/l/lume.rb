class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/computer"
  url "https://github.com/trycua/computer/archive/refs/tags/lume-v0.1.38.tar.gz"
  sha256 "f44fa6fbcf7641dc90b0cc2d445795ab8a1243c96a1c27efd3795e73674f35cb"
  license "MIT"
  head "https://github.com/trycua/computer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6a09029b56b5446d6b3155d48145bd84d6f80abb5855732ae0b21a8dc0b4c7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7098d1e016ee7194a9c4b0fb83e4911e3bc63fc4a052b4aebbf40150f0b7941"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64 # For Swift 6.0
  depends_on :macos

  def install
    cd "libs/lume" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
      system "/usr/bin/codesign", "-f", "-s", "-",
             "--entitlement", "resources/lume.entitlements",
             ".build/release/lume"
      bin.install ".build/release/lume"
    end
  end

  test do
    # Test ipsw command
    assert_match "Found latest IPSW URL", shell_output("#{bin}/lume ipsw")

    # Test management HTTP server
    # Serves 404 Not found if no machines created
    port = free_port
    fork { exec bin/"lume", "serve", "--port", port.to_s }
    sleep 5
    assert_match %r{^HTTP/\d(.\d)? (200|404)}, shell_output("curl -si localhost:#{port}/lume").lines.first
  end
end
