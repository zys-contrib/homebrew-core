class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.2.1.tar.gz"
  sha256 "bd2dfea8ae37e7bbeb10a8bcb60c309bc2800fe68a1126bdb506405d56398e20"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8778d49aa371f302647c4fa1736eb27a6b52a1160c3b140ccf24da64b463639"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc923b417f980ff9300fb352b8aec4317852f4845325ae9755465bc5da7c8e55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da9411cd3eb1f5b3d173d3834264deacf1914dd85260d51293913a5cd676df0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9516cccf7ba8edd95422147c0161214f2bd514a762288dd31c3b66f7a403f753"
    sha256 cellar: :any_skip_relocation, ventura:        "c5bda8451e78f241db13f85f64d52582e8174eabf24244320cbf1230c2a5db83"
    sha256 cellar: :any_skip_relocation, monterey:       "9b9a7581d5a53c19549a54b2af37d369ba3447d0dcc8bc2947c3c5cc68fec3cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a297dcc20811e92ffab861d8c6bf8d1cf823ed5bbd1c27c7916ab9937b678dcd"
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
