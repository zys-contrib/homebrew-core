class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.161.tar.gz"
  sha256 "b5b53903b36ddecf26dbd63418ad60e15e16a99d546fe39ed874ca26885af37a"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e64cebca775c3b216210804d58a008ba77c33152185620d81baa539fff33f8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e64cebca775c3b216210804d58a008ba77c33152185620d81baa539fff33f8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e64cebca775c3b216210804d58a008ba77c33152185620d81baa539fff33f8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b14fd9567637be42b687ccbe50333b4673ac721df646f0cb333e33ac8ee7c3a"
    sha256 cellar: :any_skip_relocation, ventura:       "5b14fd9567637be42b687ccbe50333b4673ac721df646f0cb333e33ac8ee7c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2afcccea05e9bf6a75a86ae5d6631971da537e3c8b5817a5adb1d83865ce13f9"
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
