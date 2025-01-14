class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.11",
      revision: "25d23e1800c5bb13c188eb4a3744dc119e9b858d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c032c031d4a57d55b004b76827981dfd9f024acf805b4340fdb098f96e26f4cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c032c031d4a57d55b004b76827981dfd9f024acf805b4340fdb098f96e26f4cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c032c031d4a57d55b004b76827981dfd9f024acf805b4340fdb098f96e26f4cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9d8a382ac06557ce82dc9a2f6c39cc3a47e1dc921cd026c84e94dc29f2d51ca"
    sha256 cellar: :any_skip_relocation, ventura:       "f9d8a382ac06557ce82dc9a2f6c39cc3a47e1dc921cd026c84e94dc29f2d51ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4125c0943ca7d90b7c8cf5d6a585f86a43407f30c525cdf006c217ecf2febe5b"
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
