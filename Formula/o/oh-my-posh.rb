class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.11.0.tar.gz"
  sha256 "9bafe055b48f1eb8145d2baabedfb14d1fc14c16a3e764fec4a316025ba09ff9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a8d0e5af7f7184a40fb9ecd9c090460eee8527ab839790c16c58cc2f1cf5a88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8a3bdadf52b5524a312f8b494481ef035ea60f2702c2f6f9b91553eaa98b53b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cae39823b68307568d5232453fc7012e8290cd7d22629ecd63f932f46673a6b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "59288210092a4d871b5b027f410180c2b3134c90fd32a11e5791b6a0b3a173fd"
    sha256 cellar: :any_skip_relocation, ventura:        "be4e45d810cced7b697562f1dc574a92c553d97d69fe6d3c1c221b12dcf38ecf"
    sha256 cellar: :any_skip_relocation, monterey:       "3a9e69a0fff7d6805efcad7e757fd2e2e696c1e70c06909f65c80b0d83bc7a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f3c74d7f46ee477c465ad2fe3eb1f06cf443ad3d29d210226461472f29985e"
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
