class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.116",
      revision: "a30f319b526e9cbf4668a0b73eabc071b7eb5444"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a809b9feb5ed582ce4fbc50ad20410fc933eae369efc2e6f42a0e4e364530c7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a809b9feb5ed582ce4fbc50ad20410fc933eae369efc2e6f42a0e4e364530c7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a809b9feb5ed582ce4fbc50ad20410fc933eae369efc2e6f42a0e4e364530c7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f256995cbaf28d0fd1e90251802d5f86182be5bc33a0ad8daa1571d7fdd869c1"
    sha256 cellar: :any_skip_relocation, ventura:        "f256995cbaf28d0fd1e90251802d5f86182be5bc33a0ad8daa1571d7fdd869c1"
    sha256 cellar: :any_skip_relocation, monterey:       "f256995cbaf28d0fd1e90251802d5f86182be5bc33a0ad8daa1571d7fdd869c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f43502b4d6314b4975e64461df2b665e6ae5d871aa4c98d521bf5ac7570c91b0"
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
