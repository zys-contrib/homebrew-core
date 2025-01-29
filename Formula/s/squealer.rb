class Squealer < Formula
  desc "Scans Git repositories or filesystems for secrets in commit histories"
  homepage "https://github.com/owenrumney/squealer"
  url "https://github.com/owenrumney/squealer/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "87e8cf36596f3523d65438db14ecc0ff58e4bf7f80e2183512a4118a612e3ea6"
  license "Unlicense"
  head "https://github.com/owenrumney/squealer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2896b42defe8372d585af476bca6e9ab4ebbd4f699ed077fe5d1cf3aea79a8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2896b42defe8372d585af476bca6e9ab4ebbd4f699ed077fe5d1cf3aea79a8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2896b42defe8372d585af476bca6e9ab4ebbd4f699ed077fe5d1cf3aea79a8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7269331779d20e9e1bbb511d34fd19ceba8680cf1097688274db786281b49b4c"
    sha256 cellar: :any_skip_relocation, ventura:       "7269331779d20e9e1bbb511d34fd19ceba8680cf1097688274db786281b49b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7658b35a2f1106f04f47f66b17194bfe51c9acbb2582dc26211f29fc203343e9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/owenrumney/squealer/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/squealer"
  end

  test do
    system "git", "clone", "https://github.com/owenrumney/woopsie.git"
    output = shell_output("#{bin}/squealer woopsie", 1)
    assert_match "-----BEGIN OPENSSH PRIVATE KEY-----", output
  end
end
