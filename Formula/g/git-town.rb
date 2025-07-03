class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v21.2.0.tar.gz"
  sha256 "e4193ec5d8a7f9e7ca22e12938ecab81e1d6a61a89eafc698e8b514204db7068"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c44f82b7cfb695260f8b967f43f253d6bb552846dcd9d55ab84c8d9d76822a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c44f82b7cfb695260f8b967f43f253d6bb552846dcd9d55ab84c8d9d76822a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c44f82b7cfb695260f8b967f43f253d6bb552846dcd9d55ab84c8d9d76822a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "964dd4558e5e98969df97872f92fad24a728556cdcbc259ff808337a5b69d7ec"
    sha256 cellar: :any_skip_relocation, ventura:       "964dd4558e5e98969df97872f92fad24a728556cdcbc259ff808337a5b69d7ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72912e79915db2048ae9b28b4f0202cff355b291414dc642863afc085a6fe09c"
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
