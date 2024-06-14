class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.8.0.tar.gz"
  sha256 "a3cef274086e144cc35264b7bee140e9af4ec8745d134fda345d5a8193ddec12"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06ceae447e8349ee552b61273dce417419aa33ededb0154da3ce9fb10b0d27a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afd1c94586e1a7942b0250d27e55536fca9250118d88202a960cabdbe4812108"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bdfafaf867ce278f3b370dae399865339d471b3e0198a4408a632b6baab728d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7797b1a9d979697f6c80843691399af9c6ab67dc3df7e461139f181c04493891"
    sha256 cellar: :any_skip_relocation, ventura:        "d30602a2018ebdde906906e7b8c9aa4a02052096f489535d2732c477f44c1e09"
    sha256 cellar: :any_skip_relocation, monterey:       "3b54b44afb17ed1e5cb855545ef50649a05fe7a982db8dca2a40fc8aaeee2bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d63b864500a2dc5461edcc3caa3b1524f78cf5d26508993b89d6f02e227eeb"
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
