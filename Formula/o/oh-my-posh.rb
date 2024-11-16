class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.6.3.tar.gz"
  sha256 "75b7e14bac84bcfa6f59f8f1343e68e1e95bf5ec58015632aee7ad0a20314abc"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16f2c71ea6aa55388288853d7368dfba14f8722592a03232ac23b983a0fa6790"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6424db7402ee60f2049a279905e2a5024a28383b40402444b6af1843e12aa843"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41d263178ca1349cde21168047efc2d492f9afb64cd39dd690144fa2758596e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "269be7a921554092211f5e3977a23c05ae17a1a2c31a63428025ba4d86c8cd5f"
    sha256 cellar: :any_skip_relocation, ventura:       "68abcb25d405b407e90d614a37d1b9c92a7aba026a35aa7157719856c35d1d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c92337fd99b056dd1056ea37122f8e5b1f50b5509c30f713cf4acec75178cfc5"
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
