class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "3dd3645ef175ce87f00227e6c2014592d11e764218e9beb86973ccee57a67ad4"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffecddd650604eae9d3310add80b7dd038afbaf8a380c38e4e5228e67ed8b00c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffecddd650604eae9d3310add80b7dd038afbaf8a380c38e4e5228e67ed8b00c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffecddd650604eae9d3310add80b7dd038afbaf8a380c38e4e5228e67ed8b00c"
    sha256 cellar: :any_skip_relocation, sonoma:        "06685cb47f88f02a82e76a416a491077ce161e7db9d7cf3680c1888214de9c51"
    sha256 cellar: :any_skip_relocation, ventura:       "06685cb47f88f02a82e76a416a491077ce161e7db9d7cf3680c1888214de9c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e37f2489bf1eb830a9ee08b4a7988f2d44488b174bf110e7fd1de538174d71e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"claude-squad", "completion")
  end

  test do
    output = shell_output(bin/"claude-squad")
    assert_includes output, "claude-squad must be run from within a git repository"
  end
end
