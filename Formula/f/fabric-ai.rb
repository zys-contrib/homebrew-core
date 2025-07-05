class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.229.tar.gz"
  sha256 "cc5e1fde6657d3684ceb8bcec720ff93ce52662df902975f4f3246c1cab14369"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71780457b154c8dabc161a8ed43fb805af4a83f4389e86dd962f1d3dde6c6672"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71780457b154c8dabc161a8ed43fb805af4a83f4389e86dd962f1d3dde6c6672"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71780457b154c8dabc161a8ed43fb805af4a83f4389e86dd962f1d3dde6c6672"
    sha256 cellar: :any_skip_relocation, sonoma:        "99eb101cddb3cb59e6cfdb0ec8f4f95406c920407695b65b313bbe03bbbb8001"
    sha256 cellar: :any_skip_relocation, ventura:       "99eb101cddb3cb59e6cfdb0ec8f4f95406c920407695b65b313bbe03bbbb8001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e270474c5b7f63638b250266825e5d4a09edcdda2b455a70bcbb38a40aba322"
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
