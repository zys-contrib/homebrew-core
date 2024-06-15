class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.10.0.tar.gz"
  sha256 "d07416f9ff44c61fa4db2e85725924b5f00277b7a8df7d7a48b99b3f2c586049"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea268be70b3e2a5554159f897cbd63bf3209bddd9ec8f1f960947a6aca096727"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "032e464c658d0b894585566488adca7b759db191de400dc99c84a43ad440137b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad41e459c146e3dec2c3ee1be83b51147841c44c18af0fc14279130b92569cd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5c4cc890ff20010e2ffedd6c96be89b339533a3d27f8f149278a5f302610df0"
    sha256 cellar: :any_skip_relocation, ventura:        "c3b01c4964266aace83814dc4c6bf813aa6d9dd61b5d10c03508f6ddaa4beb8e"
    sha256 cellar: :any_skip_relocation, monterey:       "fbdc7f14e673a7543abbc0a35b4de6f0560e2c292ac701115671af58af379ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6721a5e0c16fb059793d360f251a5194f6e712c5a34db47cde066b9a5ff8d4f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
