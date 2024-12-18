class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.15.0.tar.gz"
  sha256 "1218c8f67a7a516b8596bad4233fbeb785559fd0364eb03c9ac750bd4745ae39"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf4515cb53c4b4febd465551c4da40afb0c9f1e18abd7e30ad5d13021682c830"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15050f226643b33f7db2b34929f407e4b80e643ebefc816830e9dbfe9e47b7e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b95cf422e2b919ae87024a1ca392ece523c4555217c93035d9f61cf61aa2ce6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1136054b1588736e9306ab618d54a9acf8803dd5c7324ce96bcf9541fede6935"
    sha256 cellar: :any_skip_relocation, ventura:       "1ed9aee576c3309303a4c4e293d3e77777e686d5a3ddba5a44fccc417c38b2c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7632d9f3fe96df025bde0b842078bce216d08f4a422f7b54c8df2bbe39619f8d"
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

    generate_completions_from_executable(bin/"oh-my-posh", "completion")
    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
