class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.201.tar.gz"
  sha256 "eb2a684f260ec5a2dc71ad1153c60609fae491807d8aa664442e5183ca39fb2b"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6da97fd583717eacd306349798b0d7e38e902373c1b12932c64190e3978bc49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6da97fd583717eacd306349798b0d7e38e902373c1b12932c64190e3978bc49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6da97fd583717eacd306349798b0d7e38e902373c1b12932c64190e3978bc49"
    sha256 cellar: :any_skip_relocation, sonoma:        "10388075e27026916fe72090579863b667a4cd8973c1dc4cad70fc0eff6b8460"
    sha256 cellar: :any_skip_relocation, ventura:       "10388075e27026916fe72090579863b667a4cd8973c1dc4cad70fc0eff6b8460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d46f6d15ba0c3bc3aa11afc6fe74bd5fa04fc0c88e0e59e86c1e79ee91833d07"
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
