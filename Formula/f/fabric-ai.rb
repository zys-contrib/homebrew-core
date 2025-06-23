class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.213.tar.gz"
  sha256 "6a90166b97df65d8a083ee7341bcd98e687ac70b33b8bc361df0b8c1949880e0"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c51657b76ac4675072ae0ed75dfb133c709d3f36da1d21769f08ded15c2b8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97c51657b76ac4675072ae0ed75dfb133c709d3f36da1d21769f08ded15c2b8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97c51657b76ac4675072ae0ed75dfb133c709d3f36da1d21769f08ded15c2b8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f198ff152eb9fa357947939479bf49f0d11ec5ab4d4b9a72fcb8edeb2adfa3b4"
    sha256 cellar: :any_skip_relocation, ventura:       "f198ff152eb9fa357947939479bf49f0d11ec5ab4d4b9a72fcb8edeb2adfa3b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8aa262dc27fb3d28d07d159c6cbe29e6f15874b34ee44dc1d4871bd11fda387"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
