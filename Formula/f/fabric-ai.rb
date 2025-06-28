class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.219.tar.gz"
  sha256 "e3ee34f71a90f8bf56ee95941d0eafb33b6c686749b3ce63493daf1699f5e1a8"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21a262f55ad7a8eb3667914f5a5bcb037f80808e308bda5562d9bf7a5faed834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21a262f55ad7a8eb3667914f5a5bcb037f80808e308bda5562d9bf7a5faed834"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21a262f55ad7a8eb3667914f5a5bcb037f80808e308bda5562d9bf7a5faed834"
    sha256 cellar: :any_skip_relocation, sonoma:        "7405847c7ebec85bae3a23c6a097fd1dc5538827cd65e2b13729fa65c4e4f50e"
    sha256 cellar: :any_skip_relocation, ventura:       "7405847c7ebec85bae3a23c6a097fd1dc5538827cd65e2b13729fa65c4e4f50e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d651ec32321bbac447fc16fb6c5bc193c0b9bc91ab5b2e72876a4cb805996fb9"
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
