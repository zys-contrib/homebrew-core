class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.17.0.tar.gz"
  sha256 "7de5561679b4a1cc05abe9d9002049060cd470c53aca9a961348e5a169afc5d4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f867e70573f44e70ea64f21082f19c446213573f988c24c2000a08dff3a01d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70545fed22fb67415e21b6ae9bc2961b420265be1ac4658385c19a52794fe0a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ed2cbc2a2857a5c864759265037f877c7cbf8540694b0b2ac369689c97618d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fd9c20635c39b4a4dc874d3c873ce5ead00a1f387c161ccb97775f5e98dabbd"
    sha256 cellar: :any_skip_relocation, ventura:        "e8a78f4d36bafa72017ddeffa0157c15b22bfe95ccab174feca775c17f362a42"
    sha256 cellar: :any_skip_relocation, monterey:       "4e1586a303de43ecf442f4d263a1a146ec5cde66b54ce3ab48f047e90a54da4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1e3e2728fa84d06e5d3151fc4e9045ea553697c6749edb2fbb44f28be0ccbd"
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
