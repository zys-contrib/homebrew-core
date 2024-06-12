class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.65",
      revision: "107120be5a31342ac51b23518ac3a460d006e68c"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bab4e96cd64af3fac5b0bac1252e56b5e9b408ad1d3ac6b81f886e610c2e488"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bab4e96cd64af3fac5b0bac1252e56b5e9b408ad1d3ac6b81f886e610c2e488"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bab4e96cd64af3fac5b0bac1252e56b5e9b408ad1d3ac6b81f886e610c2e488"
    sha256 cellar: :any_skip_relocation, sonoma:         "72cf914622f9b915cf8d2ff94bf85ea124e289d50e01a9658edd2eb92d087720"
    sha256 cellar: :any_skip_relocation, ventura:        "72cf914622f9b915cf8d2ff94bf85ea124e289d50e01a9658edd2eb92d087720"
    sha256 cellar: :any_skip_relocation, monterey:       "72cf914622f9b915cf8d2ff94bf85ea124e289d50e01a9658edd2eb92d087720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58fd5895f85ea15d2cd00e294195d2da3c0fc9edd8f3a14ffa9a8acc45fda11d"
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
