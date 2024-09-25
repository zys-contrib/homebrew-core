class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v2.5.12.tar.gz"
  sha256 "f68f8edf78bd1c959217a69cd9c895e64fba3e4e69084f0fddc286615b1d150a"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b33ce4731535e6c40a3b4f6515df43b6b232a0d36434ed41687d7e98d7d31e21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bd36967b1466a2757f73d4342a23e32cdfe54809b2143c6fb029b6040e98568"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bd36967b1466a2757f73d4342a23e32cdfe54809b2143c6fb029b6040e98568"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bd36967b1466a2757f73d4342a23e32cdfe54809b2143c6fb029b6040e98568"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d9329a83d3dbb4b694861493f7353ea806e37188115b7af41e28dd48e7a82ff"
    sha256 cellar: :any_skip_relocation, ventura:        "8d9329a83d3dbb4b694861493f7353ea806e37188115b7af41e28dd48e7a82ff"
    sha256 cellar: :any_skip_relocation, monterey:       "8d9329a83d3dbb4b694861493f7353ea806e37188115b7af41e28dd48e7a82ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f54eb0fe6217a27daa86f69e2942c0a3534cabd67432885d221197478229e0a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output(bin/"slackdump -V")

    assert_match "You have been logged out.", shell_output(bin/"slackdump -auth-reset 2>&1")
  end
end
