class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.21.0.tar.gz"
  sha256 "fb74f7143a980bcca15a7e859273a9941fbb9d12255ceccc6c8f67cbfe0902d7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f34d39c59d674a83f7cf1a7b30fcb603afee7d67d03d1db586d489d78a2728b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b08ad676042323c92fd7cade7b1debaa3ea54f4ac37445531749eb1744a01a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff09be5eaa5a192b502cf74cf7fcd0a8403ac95df902011764fb548e14b759c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c8bbc7f70a8d4c24d3aedde9b650ee1ebdb35df1e01ff93ea28ea5ed8fc8dda"
    sha256 cellar: :any_skip_relocation, ventura:        "c82b9d3fde9a5989bbc95f0a0e5258c71f2d5cb438536ba48ccf424cc67f1167"
    sha256 cellar: :any_skip_relocation, monterey:       "9162265130ae91f70b7842121e30cd5f82ebac1fd90c10ac45e1c96148039166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "863f517c5586dc7f85ea265c84f528419c05beafb3590ae5da5d1f8ad613097b"
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
