class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.192.tar.gz"
  sha256 "1c242de8e4a12f674f2d2deaf55c6169e419257b01246bb8ac781dd5a8c2c2a2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dabf87679bf6e03a802b09af81188bc5bbda67a52153eb3aa5a2e435788604d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dabf87679bf6e03a802b09af81188bc5bbda67a52153eb3aa5a2e435788604d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dabf87679bf6e03a802b09af81188bc5bbda67a52153eb3aa5a2e435788604d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "967fa82d7faa7f51eca4d41e763b60a0d85a89ab736f957f9bd4c180d8dd4ac6"
    sha256 cellar: :any_skip_relocation, ventura:       "967fa82d7faa7f51eca4d41e763b60a0d85a89ab736f957f9bd4c180d8dd4ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21653dfe435885d076f1664f785d1d205d0228d62382929ee332f5ed4368ec72"
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
