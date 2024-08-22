class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.7.2.tar.gz"
  sha256 "307813d9994ce17aa2a987b4176afe7ce6795df0d71b473bca61c3f626d83357"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5f936c785623d81354cf4a4d506af2fbdf0ab885481607d95457d449b3bfa5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "618f0ab7e2a456c96f6009cdf25c983a89a884c4832925360729b959a477ee34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "511ceca12d4439092a8785d0aa612b4a4df3dc19767ecbd20fee49c859fa5ace"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4f376b037fa1aa511d84783f8be5fbc027b12b543fb74f93c69f2dbee6340df"
    sha256 cellar: :any_skip_relocation, ventura:        "bf7d94effc542e01cacec51222bda1a614d50bb28d5191009ec22992b7322d42"
    sha256 cellar: :any_skip_relocation, monterey:       "2b2b6ce7c5c028f8085fbb910357b1686a09422b39b369860c26fb16d70f1a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53d667c24c9250f03646a554dd79aa7f27ca754f81f5f95eb4245dbb0fc7836f"
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
