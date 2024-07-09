class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.23.0.tar.gz"
  sha256 "5132c3eb68c6811fff477cbf5bfac39d34a95576c7023f44a0f337b3b18a5e03"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb09f79397e52fd60a0803968c6971b8377ecf74e4c40ea448d61f9e9b9401c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "781b5dda33963549bc34a7ba4e4ee77add24b822ba6ab4496c5d9ed47417dc53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0e1f45efc2afdba565675b8c36b4ce6eedf46be47ebe296b83b9e33e2235fdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "46b500bcce86c2d520c68c1c70522d74f58caf878880c7681eb001436a7c026f"
    sha256 cellar: :any_skip_relocation, ventura:        "34a8738a8b74b33bd6cf357748f31070f94b37ace81b17673fc0fb34be69000c"
    sha256 cellar: :any_skip_relocation, monterey:       "cee9067eab77f20760f3c500a0d1a6149cd75e809b32edc7b096fabcfff3679f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4157721bcb367dca7e4c65c23650cf3200f408b56d5ff20dd8f4c0e02f9c7bb9"
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
