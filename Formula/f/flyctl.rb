class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.103",
      revision: "eb246f3741b8a62a2085190c153f428712e13d4c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae4a7cddc283532471750b4775fcc0d0a7ad9682b412c3278a7baeddf87682e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae4a7cddc283532471750b4775fcc0d0a7ad9682b412c3278a7baeddf87682e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae4a7cddc283532471750b4775fcc0d0a7ad9682b412c3278a7baeddf87682e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dabbbd256f1077293d5f2c39edd66ef9d5875fffcec5ffb5aa50e973d05daae"
    sha256 cellar: :any_skip_relocation, ventura:       "2dabbbd256f1077293d5f2c39edd66ef9d5875fffcec5ffb5aa50e973d05daae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbb4e4b225e1665fb638866a99d1a8a0ec4e64073ebb70ca17de2bf8e5d47a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbfa2ec2e8de025e7e3c326d613a94bf0c8477fd9bd4cd55574910d793012e67"
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
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
