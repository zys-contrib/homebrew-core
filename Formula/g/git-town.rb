class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v21.1.0.tar.gz"
  sha256 "95f74818f3c69aac3a1db03309abd3a40f95822cead5942c81137d830b60e288"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "540c384224369c2ff594a7016b02c60231be8c9493fd7960b18be4c71956909a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "540c384224369c2ff594a7016b02c60231be8c9493fd7960b18be4c71956909a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "540c384224369c2ff594a7016b02c60231be8c9493fd7960b18be4c71956909a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a630c99c3bf37ed6a8adb657028bd9797a6fd6622b0bfd744eb7df7ff3d9a42"
    sha256 cellar: :any_skip_relocation, ventura:       "3a630c99c3bf37ed6a8adb657028bd9797a6fd6622b0bfd744eb7df7ff3d9a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d3934a5f29042e4a5630954071818d3ee9a2bb8cf7062522913b03b2392b60a"
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
