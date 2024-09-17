class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.5",
      revision: "c4e44d40d1a931847c7fb15eed591e8d8596774e"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd2a15133df1df2cd5f0fcd7888b6d1065242fa35c920105fa737794a4f52a1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd2a15133df1df2cd5f0fcd7888b6d1065242fa35c920105fa737794a4f52a1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd2a15133df1df2cd5f0fcd7888b6d1065242fa35c920105fa737794a4f52a1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c60f8cf25fc02a00068946f22c668b70d07b74c6f8070c391fcde2add6be7b9"
    sha256 cellar: :any_skip_relocation, ventura:       "5c60f8cf25fc02a00068946f22c668b70d07b74c6f8070c391fcde2add6be7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f4857d20006f267f5f79d8c4e90aeb5b773b4170a4adfb8a2b65f493c671419"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
