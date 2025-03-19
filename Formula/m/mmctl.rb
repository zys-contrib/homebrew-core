class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v10.6.1.tar.gz"
  sha256 "78fc4e398cb63d11141d2915d12fbd900755eeada7ba5f239d13c2cf053a38b8"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e438f2cd6a51a683e033ce697e7c660888708f59df47ca4777e44bcc4c1f14e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "556076fdaa27b44d9cfdbc10cc906d304d1b04907dc631965c727a4818b7fa3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f9bbd0ee1ba75322fb8a48fa6e3bbe9df725923d15bcd835484af20dfde6497"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f9bbd0ee1ba75322fb8a48fa6e3bbe9df725923d15bcd835484af20dfde6497"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f9bbd0ee1ba75322fb8a48fa6e3bbe9df725923d15bcd835484af20dfde6497"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b62b1e5b52d644412d2d2ad01a9cde33c040a73da9e1d952cbcfa75e12cc61b"
    sha256 cellar: :any_skip_relocation, ventura:        "ce5037a3240ce5a32b1c0f748823c719e221eee469ee116d4a66469f8c6800a2"
    sha256 cellar: :any_skip_relocation, monterey:       "ce5037a3240ce5a32b1c0f748823c719e221eee469ee116d4a66469f8c6800a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce5037a3240ce5a32b1c0f748823c719e221eee469ee116d4a66469f8c6800a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eb33d2c49c5db76ea8afb3bb3a5b28b8c4234e7161a520c3e934f251407538d"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")

    ldflags = "-s -w -X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), "./cmd/mmctl"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
