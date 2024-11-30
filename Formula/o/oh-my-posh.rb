class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.11.1.tar.gz"
  sha256 "503ab068b16f6b57fd8d2f41c17539057c2b087b028b4127455b6251f2b2721e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a4983aaec971cb684caac999d2b17005b315e1702eaeafefa907495bace1b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "980c4455912b6dd5729bd01419cb76128be5720710001f809999cf6221056de7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89c60518b8865abf0faddd448888d9b39b58a819e065fc0c7de62d240a11b8d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "955865c6c09f4e820d714c03a89613af7f6b682fc45c542aefcb1f81af6ad9bc"
    sha256 cellar: :any_skip_relocation, ventura:       "9f55f8f965661b5398ab53d45fe7703a8e279704caff64a2dbf81b8b62f891ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b5433755cc36dcb16365d0e64380fdaeaed2a8892c0d2bae78161720b5bf302"
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
