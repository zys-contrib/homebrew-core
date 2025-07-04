class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.227.tar.gz"
  sha256 "cd1bef15db472c6d8deb72d5bf59106d3e6fa21ac364f5d91742c832a87e8a45"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "387ec8cd5a26c87393d0364b3b4881161fe3478706305e3bc9c3919ecff489a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "387ec8cd5a26c87393d0364b3b4881161fe3478706305e3bc9c3919ecff489a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "387ec8cd5a26c87393d0364b3b4881161fe3478706305e3bc9c3919ecff489a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "19c7c6fecf7c86d6cd030b0cb5244366a80306e5b15ed3bffbe03a6d36fa0b13"
    sha256 cellar: :any_skip_relocation, ventura:       "19c7c6fecf7c86d6cd030b0cb5244366a80306e5b15ed3bffbe03a6d36fa0b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79fc818eed44f99bd64090a2b14618d933580fa4814d045c37694ed739b18e8"
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
