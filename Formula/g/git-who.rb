class GitWho < Formula
  desc "Git blame for file trees"
  homepage "https://github.com/sinclairtarget/git-who"
  url "https://github.com/sinclairtarget/git-who/archive/refs/tags/v0.6.tar.gz"
  sha256 "4d81d2bdbd3fb2a0f393feb76981e33b3d31aa49bf97b4c0a69bad148aa8fbc0"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-who -version")

    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "git", "commit", "-m", "example"

    assert_match "example", shell_output("#{bin}/git-who tree")
  end
end
