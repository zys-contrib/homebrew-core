class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.11.2.tar.gz"
  sha256 "8748233f10e1b9db87844fbb01f5936efa8285787d4f8b483d97de823983af81"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d9d040c6cede1e05f817560bdada51a213fdc9c926811fe2a2f7449b69d7353"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a86fd6624ddf3376737c5ab106d1dcafce1ee2ceeccadfb0955c17aaec34ecc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4517c4a2b6f571f932d66db1112be2710214890fd46234fa67abbde4e14b0aba"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e353884624b00057694f494e19a2b1cf239b6dcf7e21e6402f0aff1edde3fed"
    sha256 cellar: :any_skip_relocation, ventura:       "3c7624554226bf7afa0bb11e24f3fa0e8410fa04621c6c8d6e197857357804a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d5a90897680b907c3d16163ffcc79a9b0699343bf67147278ab9c7aebaa2028"
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
