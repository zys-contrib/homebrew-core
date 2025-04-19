class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.16.1.tar.gz"
  sha256 "6bfe0aa257ea0db466c291f68d6596f6e0884c51970e94869629562459ba5bf2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdc08588e78e00ac8ebf403123ab862bd45e095a51f7cf0bc011f16200fadd9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2879cebc7ee0bace0eb20683cdc8df9950e0f7549dbd9b6377b47aca0fb07bf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0087bdae5ed802a2663cd8184d97f623eb56ed948d6c1a3a5ca3ab57a5a4e923"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c5af783add0197908159806071619624b62b9e1e21af86164f0eaed42e9269a"
    sha256 cellar: :any_skip_relocation, ventura:       "6d95a477b6843cf28cc3f652422f1fd26236aa57e299b69498d6525de86d0b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "026c7e7d241a3300926383e8ca839a904d3b734d0d308d250b0520f69f004d7f"
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
