class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.72.1.tar.gz"
  sha256 "8bfb1010b06c57ebab9ea2977f2810a00041f80fd9796b37616fe553a57ffbe7"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d4396dc8eb638d5ef172ac1dfc59d2ad3f218d56c632e9e3bf5f16442b0d24a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d4396dc8eb638d5ef172ac1dfc59d2ad3f218d56c632e9e3bf5f16442b0d24a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d4396dc8eb638d5ef172ac1dfc59d2ad3f218d56c632e9e3bf5f16442b0d24a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0394bdc85b99d287f812f6f1f3dbcfcd653b23fa8719134716dcfbeecdb6fc5"
    sha256 cellar: :any_skip_relocation, ventura:       "f0394bdc85b99d287f812f6f1f3dbcfcd653b23fa8719134716dcfbeecdb6fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a597c6b838037ef8f538881740de81ae7288644d96f1ba119ba79d5f0ed0eaa8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
