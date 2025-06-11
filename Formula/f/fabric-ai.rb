class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.198.tar.gz"
  sha256 "f10949efe08f8b3c8cf8e5ebfc2dafbbe3633915e71789fa5b65ad08bbfac889"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08cbf862e0a539054c457f9647cbf64967ec0a2ea0f656be060f7db523c190ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08cbf862e0a539054c457f9647cbf64967ec0a2ea0f656be060f7db523c190ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08cbf862e0a539054c457f9647cbf64967ec0a2ea0f656be060f7db523c190ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "20bb45035e1c8a3551c2b137e9b4243483e3f0d82ef72224688d9c7cc920f8fd"
    sha256 cellar: :any_skip_relocation, ventura:       "20bb45035e1c8a3551c2b137e9b4243483e3f0d82ef72224688d9c7cc920f8fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49df13c83f32c034e54bca98aaa7d8712dc7535474de6187c391a795375ecede"
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
