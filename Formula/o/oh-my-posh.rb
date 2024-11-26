class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.9.1.tar.gz"
  sha256 "4aeb8e955f58fee9010c5d48ab996b6b6570fdff6b27beac73a0d106cceea52b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "864699aa194552aa97d64b0796906d0dcb719ec24364eccd7bff9f3b4418c6c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce7406683ad6c11335c95c0ba6063b0e3c5188149fbd01dc7e49a896351c6766"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af7782fabbaea9394f92ba777c13d55206b183cba58279bf4856ccf08a0d7caa"
    sha256 cellar: :any_skip_relocation, sonoma:        "38cd4e0a1bc2a7bf8f6c2aeb582a462fe1b84794de8b4a14bad84a653179ff8e"
    sha256 cellar: :any_skip_relocation, ventura:       "134b1b70e467633dc4abb050407bae224cf7ac7e62572f3777938dc7325d309f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5dce0804fed78be3faf94e06aa0bbf96fcbf066bc9e95e1168bcf92cf6ed215"
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
