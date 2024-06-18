class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.13.1.tar.gz"
  sha256 "df7f0f61cb5b8a50ac7a915fc64d40764df54df8b2526638b0a41ccd5bc0f316"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65a538fc096ee5c37f9ee7c2e0dbc2125aa53d92a7a23f06dae522397912b842"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c5f0f55565f37867186aadc12152a502512832b432d7918947624dc6c83c671"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12d662a82b7e6d8aea2ba847ebf9038b95ddf8d3dbb678f8fb06c70827eefdbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "6068fa8f90ed0deb7499c2c544428557df4680f2796887880c4e56e9e36b9f57"
    sha256 cellar: :any_skip_relocation, ventura:        "96612f627257d5d1a03f843627d18719d588fffcd25df29ac968596e3e6fa348"
    sha256 cellar: :any_skip_relocation, monterey:       "38deca66cd974332d9fa1aa4931cde55e91fda0bb15a6020a9d0fc2d96bb53aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bc51642865221c2c79b3d297cb1ea767757faac4a94c50962330f3eb9070e47"
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
