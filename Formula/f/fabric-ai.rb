class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.221.tar.gz"
  sha256 "3e6fcda42b4eba0a8b5ae8d08426ea46905375bbf23266edf5035f475956d6b5"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58187f06cd6c42cdf3b85c3d902181083c17e5156a11c9efcb7961434c381c95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58187f06cd6c42cdf3b85c3d902181083c17e5156a11c9efcb7961434c381c95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58187f06cd6c42cdf3b85c3d902181083c17e5156a11c9efcb7961434c381c95"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ab61e4b3582639c345ba180e385ddd2fcc7ed06c4ca3e966aaf17e8952f6644"
    sha256 cellar: :any_skip_relocation, ventura:       "3ab61e4b3582639c345ba180e385ddd2fcc7ed06c4ca3e966aaf17e8952f6644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "120c32f86a011a707bda99d0db655eb51aa001a3eaa7b00c2e06c988ef5060bc"
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
