class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.10.2.tar.gz"
  sha256 "b9a9b5c028cd2627e23b5bdffd225db9d843c5d72cc11892e5e250149e4719a8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c052aa95f519b83360e35cce836ac7670eaa26a79399b38f2de4ad58c7bb9fbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b239dfa454d5200480df795a94a82e35001c899f84d68494adbc3202ea36ecbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca9d508e493f758efee75ba02fbda20d944b2358aaf3850d1d83b9e4b3fd8acb"
    sha256 cellar: :any_skip_relocation, sonoma:        "57efb533d9ae1147078124d6028c26a9d2ae805bfa9469c9c23f1bf38193e39e"
    sha256 cellar: :any_skip_relocation, ventura:       "c6cd43ac6fa40775a92a9b8017f697551c424a7c1f53717dba810c58bfc5151f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b49f2ee334731867032215cb48cbd00979c928d001984992b4756da5cf166c7e"
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
