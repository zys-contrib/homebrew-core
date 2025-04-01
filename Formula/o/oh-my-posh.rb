class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.11.0.tar.gz"
  sha256 "13694a342a2e6e91e3b4f38bf938daf6434620e901d353f8bb0a6e956212ab4a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95e17b506b7e41719213ed1f89afd71cf0b4fcdcf316dbc73ca3d502c8fe376c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ca382bff93afc298fffe06064d785352fa1de298eedf6a9b18a8e71b5fee9c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddce7e66a6a87369cc5c1f412783646a8cf033b297f5a44c6d279e8bdeb3afc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "abd18c5d9d1a48366da57e632629cdb5f70462bca29d7a6f5d7cf727afe7ca03"
    sha256 cellar: :any_skip_relocation, ventura:       "1aa12cc9c6e3518980ef005cc9c7561925edb39e93ebd20b0d95244935e016d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed6abfce9f5da2236bac617e7f153e67143ed905335a47b0f043ff6395e929ec"
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
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
