class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.20.1.tar.gz"
  sha256 "381b3da5a8f381d6cca4795296a5e2dc98e76ccb2f14129ef05c6f993db90afa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "325342ffeceeab85244e5732fcc5f1db0567d344ae516f811e08c7c912dc1b6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a4f9c72a93548dff8a44bf544cb4e834178528211a7fcc034b6ce4415c04b6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "482363576ec4ad15cebdbbe8a6921f9a08907381db12944d802cc9a04db8cdc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8675c473c46dbf90b944d6ae0843a49427227de1c4a0851ce897f78062744c6"
    sha256 cellar: :any_skip_relocation, ventura:       "1e700fe7ecc2437af98613dee60454f3b05a337a281faca9e50cf228225bf375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80c6a56c6d5621c12809543ef227ffc9603cdb9a5023ce0f0793c287c62b457f"
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
