class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.17",
      revision: "12a65bd583594e9aaba180d1c17cff5a5afc5928"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2560f51e2c014202ec7cc0e43ac24fde6f2be394dadc1de65d70b7585fc2b26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2560f51e2c014202ec7cc0e43ac24fde6f2be394dadc1de65d70b7585fc2b26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2560f51e2c014202ec7cc0e43ac24fde6f2be394dadc1de65d70b7585fc2b26"
    sha256 cellar: :any_skip_relocation, sonoma:        "034e1eeafb35bd61a2602f9188dbcb47c1a120ee8fec8c2be415864e3ac5b583"
    sha256 cellar: :any_skip_relocation, ventura:       "034e1eeafb35bd61a2602f9188dbcb47c1a120ee8fec8c2be415864e3ac5b583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a771c1be0b9317c21a14ea437ccb47e5dd712b37f50daf3e8fbf3d004b3d0dd"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
