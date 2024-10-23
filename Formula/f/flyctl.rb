class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.28",
      revision: "7b8546ae9623fde6e64d3964b2042fe25147cca8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb599a5ddb50e974b728751ea5aa7f284bc121ffbb744fe110ca0bd3b3495b8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb599a5ddb50e974b728751ea5aa7f284bc121ffbb744fe110ca0bd3b3495b8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb599a5ddb50e974b728751ea5aa7f284bc121ffbb744fe110ca0bd3b3495b8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "25b263e3ee56f5a554134f75cc7735ecc7f4e2830309104ed944a6104aa7cb9f"
    sha256 cellar: :any_skip_relocation, ventura:       "25b263e3ee56f5a554134f75cc7735ecc7f4e2830309104ed944a6104aa7cb9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f869ecac4952062bc1db3d3e61c3ef472527a4c3c3cfc04c4f478040909a049"
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
    generate_completions_from_executable(bin/"fly", "completion", base_name: "fly")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
