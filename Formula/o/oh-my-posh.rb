class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.7.1.tar.gz"
  sha256 "332b38f5eda5aa952aa52d3e96675c73717b47c1a37fad8a2ce959f1a099f26e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d954e8d548c11125be5f49658aeb77d753d1d457ddb9928052ac7bc646bb4c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "637a3bd04fc3487e7183acdab38696f5801a7671980664c8cd2bd8ae837a641f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b57cdf2e979c2c7cdf39d027341ad83f17de487af68efb934b420299fa3d3ac5"
    sha256 cellar: :any_skip_relocation, sonoma:         "09ffae5d9eca666cf1388820d59eb8fecdebde18f96c87c4c50f85e2a84be637"
    sha256 cellar: :any_skip_relocation, ventura:        "91d5ba5091eb74e37697cc808b456c71fedb83180bcf1e080b47209adca6a9f7"
    sha256 cellar: :any_skip_relocation, monterey:       "95fe73543f3fc934bde0615275161b7e182c5400ae82b6510283917bab058b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d0695379d5bb6c483ac2e052e4b9a68d3dffc49ac549d226de57ee03b4513bb"
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
