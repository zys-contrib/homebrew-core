class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.26.1.tar.gz"
  sha256 "69051ee4e255f45df0ecebf684240442e1261de93a13cba9752d1172229b6562"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef3d0dd39ae25c58596b6a9f2718cc1cfc89df9634966cfd18faa35dd82e2b68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a072c5e99a188ada1384240ea4ebaeb39ae1b0a037df28455c7646fdb189d61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce8f4068e54127429ac5b6efb7eadedd90a566842000970b89b2b9302f365371"
    sha256 cellar: :any_skip_relocation, sonoma:         "e29738f192e5957a2f1c97b02ac43567235c14b95f81e6ffd66ca2fd8706cfe0"
    sha256 cellar: :any_skip_relocation, ventura:        "af65a92e2026d9ab1e43af7206a413d51613a1d6f2c34850cf09778d9d9050c8"
    sha256 cellar: :any_skip_relocation, monterey:       "fde2d4ee502d78b2bbfba5e4813289cf9af1bb7494fc0859bc65f6668c477e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95363cb7f03d7afa724379963ef379e7ea59a17afa10d7398fe4f1e3bcac6a8d"
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
