class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.71.2.tar.gz"
  sha256 "f63adebce6e555005674b46ea6d96843b5e870bdb698759834276a69a121875c"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecb1be30d44c8df52e76f2b3f92fa858e1604eba4ed85c857a6cf82e4a6f496c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecb1be30d44c8df52e76f2b3f92fa858e1604eba4ed85c857a6cf82e4a6f496c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecb1be30d44c8df52e76f2b3f92fa858e1604eba4ed85c857a6cf82e4a6f496c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d740e646ff40915fdb4a286d56015f3e6a17fd0cbcddd13bacb9c2ee3087bdf8"
    sha256 cellar: :any_skip_relocation, ventura:       "3e1decbda445ca3be77f16c31c90c7ff8cb1552259bd192c6d3704d57af34a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d7a8eec7ef20d04c8d1397d60a99ce34de1dc16490fe2619f3049cafba61acd"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    with_env(
      "GH_VERSION" => gh_version,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
