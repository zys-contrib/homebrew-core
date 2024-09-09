class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v16.1.1.tar.gz"
  sha256 "0ced1fbd47904dce0addc584f572f43ba965c25c9b38a5e4f7ebd481852e67d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6322112334a3c35206a1b89e02376868f44d5d8c5d0ce2097a048658976a4fbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6322112334a3c35206a1b89e02376868f44d5d8c5d0ce2097a048658976a4fbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6322112334a3c35206a1b89e02376868f44d5d8c5d0ce2097a048658976a4fbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "c05a2b43e11d3774266c5253b7ebbdefd97f8ddea849640e5ab37f8a822d9609"
    sha256 cellar: :any_skip_relocation, ventura:        "c05a2b43e11d3774266c5253b7ebbdefd97f8ddea849640e5ab37f8a822d9609"
    sha256 cellar: :any_skip_relocation, monterey:       "c05a2b43e11d3774266c5253b7ebbdefd97f8ddea849640e5ab37f8a822d9609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "124713a8e7c2a4ef245722e5933f9277a047d21fbc94849ee7166512bd198dfd"
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
