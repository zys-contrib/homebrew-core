class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.5.2.tar.gz"
  sha256 "74cc35ee2d74da52a232355e6f89b924e49e453ee0c3ffdd0783742fc7768db5"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcecea513a695f934a585fe63e9fd9bca698944e4dff37d1e211dd20824ea635"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91dfb36babcde1c86cc35c02a7d4a775ea9e62f93a1c074a89d3adfb6b883965"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc728bfff0df800977de3813550d44d0637e74a87683b1afe8abab235fb9517d"
    sha256 cellar: :any_skip_relocation, sonoma:        "50dc41aebf458c26e72c21fa7184de261b15bc9a07b3907cc2693676a54b3bc8"
    sha256 cellar: :any_skip_relocation, ventura:       "a1806cb10c3a4cd3045e5e58d58f0c03d5b7b0b5f8e7cf77c712a40e727fb846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e3740eb12587515950f4d41a8fc92c2be7d9797ba20bc7b9d9077fb75fbd19"
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
