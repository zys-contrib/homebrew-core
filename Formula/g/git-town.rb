class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v16.2.0.tar.gz"
  sha256 "3181cd1988f14fd7980cf9efba60b3c78e7bfbba583c728b1bdde2a294529e85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a74580b62c5c3c3e636b0623a2f07a3cb1cd11e2b492796735c68681e0a4284"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a74580b62c5c3c3e636b0623a2f07a3cb1cd11e2b492796735c68681e0a4284"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a74580b62c5c3c3e636b0623a2f07a3cb1cd11e2b492796735c68681e0a4284"
    sha256 cellar: :any_skip_relocation, sonoma:         "730dadc041bbbd4bc65978b57cb995492d614e5beabfb2c75eeb8210479a3205"
    sha256 cellar: :any_skip_relocation, ventura:        "730dadc041bbbd4bc65978b57cb995492d614e5beabfb2c75eeb8210479a3205"
    sha256 cellar: :any_skip_relocation, monterey:       "730dadc041bbbd4bc65978b57cb995492d614e5beabfb2c75eeb8210479a3205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c31eba5ea21dc3540aa1dcb25aaf94a29e26cca678317d94c1995ab8bef4b2"
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
