class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v21.0.0.tar.gz"
  sha256 "cdedcb8558822d808d3ff5fea0ba9efc207b8d7b3a6babaaa3378e6ad12a2ae8"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "127fe76c2773942ded97c46ec5285bb60dea631cbd825eff2b71766c0c552390"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "127fe76c2773942ded97c46ec5285bb60dea631cbd825eff2b71766c0c552390"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "127fe76c2773942ded97c46ec5285bb60dea631cbd825eff2b71766c0c552390"
    sha256 cellar: :any_skip_relocation, sonoma:        "79f8eef2e287c62cc2ed7c9fb0ccb6f3ee8ef5d1eaee6c79e7a23007e4c7fe38"
    sha256 cellar: :any_skip_relocation, ventura:       "79f8eef2e287c62cc2ed7c9fb0ccb6f3ee8ef5d1eaee6c79e7a23007e4c7fe38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1228a541af84f3a1a4d048a2b5af00fac0ee8d916d000178531665222bec357d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
