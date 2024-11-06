class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.0.9.tar.gz"
  sha256 "d58609cb875ff8ca1245b1b32a955328592d053fe45123dc60a7047326d352f1"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f14a4ec950797cf8812d622c7603d92e976c6e57808064b5228f0da87831292"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a303e56c6fb8289c2bbe8eda750594b50c0021067e298a2108c1df7abe4b55d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8c78c56d2f295b2ec8a83bdecf558ba961ee36ba6326892402936bb4368d0e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f20f1cd45ebf4293958a8c23603645b5e9b5131996a1ed195cef3017512a665"
    sha256 cellar: :any_skip_relocation, ventura:       "3a4bba8470c0cb35e7f3f43119d6ab3cb1eafb6c2e5a72a5d442196a6e1df616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5887e8fc2327375a2ed6cfd1af3f9ca5708d7cd3ec3b02ad60f58aa8d8f00387"
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
