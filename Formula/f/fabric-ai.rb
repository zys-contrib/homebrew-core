class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.171.tar.gz"
  sha256 "6b2c59c3f97f4930e823b94aaaff85c4943353fdf7f0533e056014b462339764"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "552eb5a7e1f33b646e5b42603c3206bd51001e5a4a876d91ee0ed9a09a01a7be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "552eb5a7e1f33b646e5b42603c3206bd51001e5a4a876d91ee0ed9a09a01a7be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "552eb5a7e1f33b646e5b42603c3206bd51001e5a4a876d91ee0ed9a09a01a7be"
    sha256 cellar: :any_skip_relocation, sonoma:        "bffb5ea01b83215a7c55c060a57da745d83f28e3d372a5aa52efeb920e0430f2"
    sha256 cellar: :any_skip_relocation, ventura:       "bffb5ea01b83215a7c55c060a57da745d83f28e3d372a5aa52efeb920e0430f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be2c63b19567dbb3d095e5bcbdc193a461c73be178127f5ece31333bc93c093d"
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
