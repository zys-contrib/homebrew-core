class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.9.0.tar.gz"
  sha256 "7559c93bfd2886129450020605fae8fe3e75aed197b35c4e1d348d1a75f0df11"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32c057e751e90029472cc3de2065b6097c03694d3fdce1161c8b44ad250def88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ef0417912fa5ef65921642c05ae29bba464035e825e54176a59e0890dbb7a7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54828cdf53bcb7d61a07e99cde70ef784a3d482a7ad40f6c6484df7b1d567755"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2f715c11569bfb362973a8f376e8b0915665ccc839497facfbe72804711f668"
    sha256 cellar: :any_skip_relocation, ventura:       "55ab9cfa1c5382d3d2e4963e9c1b58cb0b2002570930359097385508d452a4df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07fbcd6b0e0c8f5c0b5180ce922dadaee875a15c9dfe9d05b0a19aac85f24337"
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
