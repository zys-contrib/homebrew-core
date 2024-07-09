class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.22.0.tar.gz"
  sha256 "1999a58fa2748a313a3e2bb09b58d4c3d317461dbc893583e47ab78d90624367"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b812366d604219f4f035dd5c2d28185a1472bbdd81ffd770238846a114c708a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc6b901868ad9fe9cf08b1386c42bbe8671145939c8685c3b21f6a8aa79913f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41cca3c5d0e5d0c377a72515072a59446b53d362bd187eb160a2823d11c90426"
    sha256 cellar: :any_skip_relocation, sonoma:         "9970d9865c7a8646b22d7c9d16bcbc27619c34940cf2fe5b3204ffadf28f2b12"
    sha256 cellar: :any_skip_relocation, ventura:        "7ad3978e9bb574f1d739e1d6cad373a7e48399f20a78aa319bc1fb247c80b312"
    sha256 cellar: :any_skip_relocation, monterey:       "648d91d415afdf07e12824cb2177e13a5597fe47499e52ec21b354224cab5564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "335029bfa26de37c0ce855714b43b64f6c90fd064f7b8f2c1151c865b1924aad"
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
