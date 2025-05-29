class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.0.1.tar.gz"
  sha256 "62120fe20ac17538ae9e881a247a60b7c7adf41be6dadee81cf5c227d9e85d2a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1745ed3c0acda451d8573bc76266c59a9e33a42eb1996139d2de22e9dca9dbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca1e5f8b827617e15c785fe463a664803b70caf7e2887539e7a668e082edf9c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63e4cd06ecc51bb8f824f54f3ea2958e19f8340c67b0db2e7e57e3e69d652be8"
    sha256 cellar: :any_skip_relocation, sonoma:        "990b4cf239160e58ed5d3ceffbe908f1766802c03d93ea7f4e0223635d5351f0"
    sha256 cellar: :any_skip_relocation, ventura:       "e46e93fc51aae05f432a1ccb34d9aa2b775ff17c2fcf666131ca84da3b0d83a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a32a61225da785b70189cdda20c582d9247038359327360841cb815ce01bc0b9"
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
    assert_match "init.#{version}.default.sh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
