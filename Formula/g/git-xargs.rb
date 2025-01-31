class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "18122dd0b524064920a083937b18ee50533200425110606b6f204c0a77bd31aa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a697827b5c1a6c51816a023c785d73c1bcc0fb511e6d98960a5eedaeec32fe32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a697827b5c1a6c51816a023c785d73c1bcc0fb511e6d98960a5eedaeec32fe32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a697827b5c1a6c51816a023c785d73c1bcc0fb511e6d98960a5eedaeec32fe32"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ef413c4a0c4d2719a18b832a360168b293a11d2e31fa903d8ffe5337922b3ed"
    sha256 cellar: :any_skip_relocation, ventura:       "8ef413c4a0c4d2719a18b832a360168b293a11d2e31fa903d8ffe5337922b3ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed83fd2f7e10a505d944252c721bc2c577f52682eea7b1597194faa4b337de69"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-xargs --version")

    assert_match "You must export a valid Github personal access token as GITHUB_OAUTH_TOKEN",
                  shell_output("#{bin}/git-xargs --branch-name test-branch" \
                               "--github-org brew-test-org" \
                               "--commit-message 'Create hello-world.txt'" \
                               "touch hello-world.txt 2>&1", 1)
  end
end
