class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.206.tar.gz"
  sha256 "7afaaaa5689687dc084b500020e9ab1392626f4d60847f6e804c74185d0bf08d"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f215864dbb73996c79d3c193e94967ed2d99aa896062efc866cdbfcad21a5052"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f215864dbb73996c79d3c193e94967ed2d99aa896062efc866cdbfcad21a5052"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f215864dbb73996c79d3c193e94967ed2d99aa896062efc866cdbfcad21a5052"
    sha256 cellar: :any_skip_relocation, sonoma:        "d310da80b21ff45f097cdd71f57ade6907e67e5bb97075210cf501f0c1e3a685"
    sha256 cellar: :any_skip_relocation, ventura:       "d310da80b21ff45f097cdd71f57ade6907e67e5bb97075210cf501f0c1e3a685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "546c9f99d298f886ccad312284bf315a42bc5d60626946142bca088725316685"
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
