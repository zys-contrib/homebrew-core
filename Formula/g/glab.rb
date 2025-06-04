class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.59.2",
    revision: "c0acec3f3bab0b433fabf487e0a71c780680ba90"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0c22c20b75a00d002190700bca50f94ca55a470558674354c5e3879eee06363"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0c22c20b75a00d002190700bca50f94ca55a470558674354c5e3879eee06363"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0c22c20b75a00d002190700bca50f94ca55a470558674354c5e3879eee06363"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c229cd5cab04d393000046eed0e9f93730e8c441b414d98f87ae111e3c9098d"
    sha256 cellar: :any_skip_relocation, ventura:       "5c229cd5cab04d393000046eed0e9f93730e8c441b414d98f87ae111e3c9098d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04c98ff8a276cbd1ec0bc13e8dc97540834ad4e5aef759064ac5e0ed5e2e3cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52ced05859cdc9c2ec83f0af4638cb04c137ac1838807ca5b3de4d275538d67e"
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
