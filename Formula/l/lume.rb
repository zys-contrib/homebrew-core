class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/computer"
  url "https://github.com/trycua/computer/archive/refs/tags/v0.1.13.tar.gz"
  sha256 "6ea2ecadf81a473f00235b8041ed113143f646faf71ee70a6ab4d3ddd8883bd5"
  license "MIT"
  head "https://github.com/trycua/computer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89ff53f20fb71a898cce25d8d52acf63bf806defc7be2bf5315442510b8510f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98c1bf7b95da61037616926f8d1c34472ece46e2f6af069a09e5406c4fdbb709"
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
