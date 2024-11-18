class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.155",
      revision: "80bb1921c6ebf615e9e9472a96c5e8ac08c1b358"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beea984b2902e50ea75822ae0a1a44b2edc5056435437ddc35a2e90286a03a75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beea984b2902e50ea75822ae0a1a44b2edc5056435437ddc35a2e90286a03a75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "beea984b2902e50ea75822ae0a1a44b2edc5056435437ddc35a2e90286a03a75"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6ed248d1fa42c6d582d359b5d86f7566d502ea8026f6e0fbae9405973342363"
    sha256 cellar: :any_skip_relocation, ventura:       "c6ed248d1fa42c6d582d359b5d86f7566d502ea8026f6e0fbae9405973342363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf4f1d12409995216b967e0e941a024109265d41120019503a75108f78f93b63"
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
