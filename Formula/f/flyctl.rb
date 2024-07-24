class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.96",
      revision: "0487be13fd272e3cf7e0df984f167e652ea75c70"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fdf5de0a3f621e9251787bbf2d05c43f725659d630166f3ec61a1135c8ba94f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdf5de0a3f621e9251787bbf2d05c43f725659d630166f3ec61a1135c8ba94f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdf5de0a3f621e9251787bbf2d05c43f725659d630166f3ec61a1135c8ba94f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "92c33d007d4a1e6423e0702844ffcec3b27d1569ab895e1c92dcda01e0193be1"
    sha256 cellar: :any_skip_relocation, ventura:        "92c33d007d4a1e6423e0702844ffcec3b27d1569ab895e1c92dcda01e0193be1"
    sha256 cellar: :any_skip_relocation, monterey:       "92c33d007d4a1e6423e0702844ffcec3b27d1569ab895e1c92dcda01e0193be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c9a46c6ebdefb6b58d6793ba490fbce3e88e9a431d5004854925c0f74bee82d"
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
