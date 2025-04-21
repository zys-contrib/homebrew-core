class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.177.tar.gz"
  sha256 "098b09444a49530713df77b1fecaf2959df0cfdcf46d9f2bf4728feb9bf58831"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e97a6274a2313ce3cf8f3bd72ac6de1cf9021e5816cca106fed06ef9b68abc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e97a6274a2313ce3cf8f3bd72ac6de1cf9021e5816cca106fed06ef9b68abc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e97a6274a2313ce3cf8f3bd72ac6de1cf9021e5816cca106fed06ef9b68abc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "849c8d5afbe35571f33dea072bae3e9eb3e2add968f638dfe5203bcd0331bd21"
    sha256 cellar: :any_skip_relocation, ventura:       "849c8d5afbe35571f33dea072bae3e9eb3e2add968f638dfe5203bcd0331bd21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec9aac8c1f0dda9dca31353ed0410936c233bab8632b1e2439b909476e562ffc"
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
