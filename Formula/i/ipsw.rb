class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.621.tar.gz"
  sha256 "bde0adeb91f076aa4e34e0c0e520ae9e3e4edc3f58a654bb245ecdea22f5a73c"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d46376ba6081351bf3a4bb7fd02f7be567b0004abd1895986ddcd48e991fc12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ce4f7e0ef1f8328d36554bc8647084ba6ab5267a3682448aaa9e10158bd656b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e53e86609ad5effbdb97d4cc96ee8046faf4769bddd0b63fd5aef33f173881bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "257a79d858d39cb5e25500490023aeb7a550194fa7d74a5fd05f1e2bd584f8fb"
    sha256 cellar: :any_skip_relocation, ventura:       "8cab69458235536a476421029d2a8693bd68cc063b2810f0adc1988c9628ace2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af7ed86d05c1e9f8071a1b462c2ce9a8a6a5459ef319604f693bcc019caaec71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6915b0d7e22a7a36f3e91c6ec4265988677156c44e5046ba3ef789e5a181dc0a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
