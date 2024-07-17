class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.26.4.tar.gz"
  sha256 "b17b0dd9533a92ea3c736ee020997409c5dc4bcc1292ed2114f77b186ebb62a6"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aed9dfdf13378a3cdfb69f86f4ff2a296752e36683f6705a3c98afb6d8f02838"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69887405dd2b05fd2f71095cd6869b380c1289d4613fe7f1e8ee0a2fcf67d323"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77315514aa425cb3bfc3f3043e57d5c534cea834b8f83f2a40d950c450908956"
    sha256 cellar: :any_skip_relocation, sonoma:         "8beba88fd1c915c669b41ecad76909e4954743d357440fad107e8c0a849c3491"
    sha256 cellar: :any_skip_relocation, ventura:        "2df109cec53f0833d0b9269223ea81fc0e402b8dfa588c86f83babb393bcac66"
    sha256 cellar: :any_skip_relocation, monterey:       "d2701a89d0755489d8e97a4d990ed53afe21c0c71e4ea4cfa30dde7ebb7c89c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4b07789b9002543d756e0d85fc17505bc74e1350fafae71ee386962cd61c1e7"
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
