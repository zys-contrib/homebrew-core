class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.10.1.tar.gz"
  sha256 "3f2b8685cf1c74ef49187fdef71357800fb176ee59fd179e8212efc397694688"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5980e1a2513df348214f06d65666b90e5ab3bdd29eb959e65e79609b706b779b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc2f565858c60dd0d3d926bf4ceba676a9a096492a55ff46be563c1b179c8b90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d64bd141f0ecd31e488dbe8d273ff092a7473952237c1096cfd8b9a163c705e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6ff16488d1fb763783ead493464f9b52e183d005ab9cdc1cf44eba29ad7adc0"
    sha256 cellar: :any_skip_relocation, ventura:       "c93b52967713fc42b6de7421cffe48363f5ae023cb6bc176255b0f8c438631a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d16cc0c449cb6d744910c2fdb5fbcbaaeaf7077452b0ccbc319884ac64244939"
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
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end
