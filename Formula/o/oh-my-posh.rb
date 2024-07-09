class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.21.3.tar.gz"
  sha256 "17d5b9da76340f25944d7aeb8ae2e82a44dcf5e64088a54b3f2caf5debde3f43"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6bc777e78a65eebd2fd94bddcfdf431b3c4f9ed446a8cedfb895a0fa57c6451"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "399452eef70bdc2a8b71a03da61dfb8ddbcba762c689c47083fa02a86ff267ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a854d1aa42a6576abaee8531e573657ac037958076d15dcce89be166645e3047"
    sha256 cellar: :any_skip_relocation, sonoma:         "5eea11917eeddc0c7f698cd12ebb22bd12e5d046d18374087294181d639e5b3f"
    sha256 cellar: :any_skip_relocation, ventura:        "f28a4aa10829954250829106919c3f5dd63cee5452ad63cc2c89f5b0b7cfd5ac"
    sha256 cellar: :any_skip_relocation, monterey:       "e16a7de57e72fc15c08c64c7f74b57013598044b2710547c93516c4f47c1041c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e84895721add6dbfa64752fdc3c691cc9c611e1f419042f37e90e60498072646"
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
