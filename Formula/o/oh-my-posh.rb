class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.9.1.tar.gz"
  sha256 "21711cdc29092101b54712fef2692f77b38e3cffde33a4e218ed30a039031338"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87888f069fd4113cb731185bed04a3f9e88e0d171f552320570ccfeb8c046a44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fd5ebd0294541863ee06f847852e526e6b9330038a45dd31232f1ba517bcac9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72cd1d05b6fb0e40ac82f94e25a93da073ae2c1880002e6ca6535ef142011f17"
    sha256 cellar: :any_skip_relocation, sonoma:         "349be69a718443f0d0ee80479b40274fd023fad6f82acc209d5d9ff28f0d22cf"
    sha256 cellar: :any_skip_relocation, ventura:        "f8307a17e50d9be25d674731bfe98548b225632026f06201180425247bd56631"
    sha256 cellar: :any_skip_relocation, monterey:       "35a49722329eb74387e7f3b73151780790a457b0c278c0089aa33038ea290f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e99b944ee6a6f8d264d9fd08f5bff42229e3ab03a099eab989a7774c0d341ee"
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
