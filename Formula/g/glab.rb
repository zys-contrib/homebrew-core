class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.59.0",
    revision: "1df93d661dd40cebcbf3d0042dcb9291023dcbf8"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aa551ec43c1d164b2a90f12776e336d73f007b240325cacd32c6f18680ced48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aa551ec43c1d164b2a90f12776e336d73f007b240325cacd32c6f18680ced48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2aa551ec43c1d164b2a90f12776e336d73f007b240325cacd32c6f18680ced48"
    sha256 cellar: :any_skip_relocation, sonoma:        "36def14986fc346fdadba874fa0cb99233c2d51aec185637d2cdd378d5d31075"
    sha256 cellar: :any_skip_relocation, ventura:       "36def14986fc346fdadba874fa0cb99233c2d51aec185637d2cdd378d5d31075"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9f2700e7a6898dc7049ad0dfd432167e10671708f60f769eb95b881f26710ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4222c0ce1d99b641f46ba04fb319b5eb51eaf2cc23198f07c2a63b173bdbcca5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
