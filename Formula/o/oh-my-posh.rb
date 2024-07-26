class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.0.1.tar.gz"
  sha256 "2ec5aa1cfe821a0d0c2bc563282c961c0d4479b428c030f58640c03ef7099922"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e9d60c523afb92699308686d2377288a7184458e10fb72207aa13ae32254f75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5198978710325fb88378f6baaf76df39b98945016ea36b7651e4b333ea34b014"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "198a6b2a56f9efdba087149e907228275369c0c8a0939aee69dd3b4ecfebb27e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe67029be155296e033ae5f8f12d4231c1ad1ad10d50900e99de9ea0a7083fc8"
    sha256 cellar: :any_skip_relocation, ventura:        "d1479dcd9aa85fe4464c516e4075b8e47decf72d942597bbae8fe2ea69582477"
    sha256 cellar: :any_skip_relocation, monterey:       "20256925440be4cb4aad72a3d294d752f5d2d25b96c9cdaa34a5be8fed731127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c4edf764e113e9a17476e1e8349cf8c8359a7481bfc3e4ba436c05fb4fea422"
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
