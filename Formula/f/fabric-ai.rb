class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.168.tar.gz"
  sha256 "d68edc138b1879a0d500552cd5dc58d00592df8e1adc3be3ab959faeed8c4e57"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc80c89309a1b12c9a4054210f13cdc4a9d30bcddab410f415e2759c2f74213"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfc80c89309a1b12c9a4054210f13cdc4a9d30bcddab410f415e2759c2f74213"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfc80c89309a1b12c9a4054210f13cdc4a9d30bcddab410f415e2759c2f74213"
    sha256 cellar: :any_skip_relocation, sonoma:        "c534a89aced28f6ba4b8c729bfba3a1e57a8c8ed47d4612c3558ffbcd8556d04"
    sha256 cellar: :any_skip_relocation, ventura:       "c534a89aced28f6ba4b8c729bfba3a1e57a8c8ed47d4612c3558ffbcd8556d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41ab242ec5cbb790b54e56e699289b8764fd57137003b7a8ce40733c987d02c8"
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
