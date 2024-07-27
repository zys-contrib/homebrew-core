class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.2.0.tar.gz"
  sha256 "50323537ef6c7080ab479166b6dcbbd8621f4f23367c098093cc57d1afd3ba17"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca62353139eeb7017d94494bf5742d3fa761d49bd99dfff5caef1fd6ba484112"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "561c9fe0f5e021955291cb8085ed3eb22379b01720bc78325640e8c48db92123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f68dec54af9c73f594d7c6f039fce7f45e35534b4b5b92c844295bbe09bd3f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "26a7dacf279333a9524a6c28c7328ff270e3aa2c0c7baa67fa85270f0970455c"
    sha256 cellar: :any_skip_relocation, ventura:        "a1c59aaa4e4ca77eaccf06b1582e48cf22cd7f7fdfc2aa47e204e710a747f0bd"
    sha256 cellar: :any_skip_relocation, monterey:       "d5fba75c4322e45d29c15f6f990061f9ac82c9459a488372974e388c5fd061f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b8555b8f708df6d16d30b6740017b2f5273bc35648a1387132c6a1d8600bb7c"
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
