class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v22.1.0.tar.gz"
  sha256 "12bfe444efdb0f9e193b342d576cd232358d87c537cd22d4a33bf9da8760576b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfecace0223bd4bb21545f91e7ec3a83f44c62257669dd4c9c09504ae904661c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1d78600d69bfee3db1d2dba9b76128f20150d4f9915cb45ee2e4f5c75e9dfae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "add732031936ab7306625f7cbc66391e476aa76d18ee5a9b18f87042f5fb4a68"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4661793e838100016bf2e22e2add83ab6fe4bc8ac3ce0c9dd359543ca7dd24c"
    sha256 cellar: :any_skip_relocation, ventura:        "40e4ea7389d78c0b45ecf637bf227bdc2acf7d40ed65527dae1ddc6418c6fee5"
    sha256 cellar: :any_skip_relocation, monterey:       "b76945008ebb273702dbc317893aafa415585220d3d6a72dcf306fd11b9cc6e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c3e185911a8bb0c03f601a5997cd35027d68a967bbcc569cefef1ba92492649"
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
