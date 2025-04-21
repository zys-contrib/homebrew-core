class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.179.tar.gz"
  sha256 "6ec1f54b170c0d8ba1d1e9c54fcfeb152c06d23e98055fe74418c7e4ea44bc9f"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97f48dc1ea469560d22ca057909b2b6f169784f97328b0d960bc1d6e17fa1c02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97f48dc1ea469560d22ca057909b2b6f169784f97328b0d960bc1d6e17fa1c02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97f48dc1ea469560d22ca057909b2b6f169784f97328b0d960bc1d6e17fa1c02"
    sha256 cellar: :any_skip_relocation, sonoma:        "4450dca552e883eb4097ddcd4eebe527172fd3cc9fe02139bc7a63eeb60889d6"
    sha256 cellar: :any_skip_relocation, ventura:       "4450dca552e883eb4097ddcd4eebe527172fd3cc9fe02139bc7a63eeb60889d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ec18a3ee5640f6199bbc9851643e4cb47425a65edce590c917f64f531d05d39"
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
