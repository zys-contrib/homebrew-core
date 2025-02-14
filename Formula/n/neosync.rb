class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.20.tar.gz"
  sha256 "2a2cf799d64e5b66373ed8c5f38f3eea572282e9cf5506587face536fea93a00"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d95797e84b36b5d7a4a5ae062085bbd7604f13078467cffb364e4a28b5a2b51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d95797e84b36b5d7a4a5ae062085bbd7604f13078467cffb364e4a28b5a2b51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d95797e84b36b5d7a4a5ae062085bbd7604f13078467cffb364e4a28b5a2b51"
    sha256 cellar: :any_skip_relocation, sonoma:        "b58731cddee55c91a403cc73e6069948dcaed30999cd340d6a9268c2b3771889"
    sha256 cellar: :any_skip_relocation, ventura:       "b58731cddee55c91a403cc73e6069948dcaed30999cd340d6a9268c2b3771889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3454d84595975b18da5067289747812f1931287391e5e5190e9059c7ce56d4f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
