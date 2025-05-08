class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.22.0.tar.gz"
  sha256 "9d17fcbe8cfdd923ab1ddd9901599b4880c5c86dd12e1882e95b8643d07d1a1d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c2b03a5bbcd392e78798507330ea9e1a878c8e910b813ac6baa5594eb3b6a30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b0354f7491a0f979b1d4ab37068b7118021c071ab19b243a1954a262ea6e80c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d95d72d01a41bb25800d849bfd1ec7c2898ab023c2042028ee1f8eb476c3bc58"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0303501a1da3996bcf78d3f76c286ebc40ef05eba2db88bf258efe411c746d0"
    sha256 cellar: :any_skip_relocation, ventura:       "c9df44aee0b0ab934a9bdb9a091ee4b8276e365dd6a5b0913df9aafdde7990b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c5624556a84edc845944d21d26e1129e7775e99414db16ea217d67c32599559"
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
