class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.100",
      revision: "10e2b90caf69b6a248d2a991789e6f4d0a27eb41"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3e93105739e78d0b6d091c52dc6e27a92cbf2697f7d29e6060c68b31ad25388"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3e93105739e78d0b6d091c52dc6e27a92cbf2697f7d29e6060c68b31ad25388"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3e93105739e78d0b6d091c52dc6e27a92cbf2697f7d29e6060c68b31ad25388"
    sha256 cellar: :any_skip_relocation, sonoma:         "160bab37382768909cd222086e65f5813deefdcec0e844536aa8ef5e1b04a487"
    sha256 cellar: :any_skip_relocation, ventura:        "160bab37382768909cd222086e65f5813deefdcec0e844536aa8ef5e1b04a487"
    sha256 cellar: :any_skip_relocation, monterey:       "160bab37382768909cd222086e65f5813deefdcec0e844536aa8ef5e1b04a487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adb1b10e9db2d0e436f966a471653f68b576349192bba94728da7aa93f8bde75"
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
