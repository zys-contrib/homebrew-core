class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.72",
      revision: "1b9996e62a3b6eb0df41ca8f2d3b613cc87b1cec"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae5ba3ff44491368fc6a3395fe45e707d274b54bba97cff8f2beecc6f825e7a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae5ba3ff44491368fc6a3395fe45e707d274b54bba97cff8f2beecc6f825e7a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae5ba3ff44491368fc6a3395fe45e707d274b54bba97cff8f2beecc6f825e7a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "920641200760199715388115f903d4fb9d9855c0461a6713ab66dec9563006b6"
    sha256 cellar: :any_skip_relocation, ventura:       "920641200760199715388115f903d4fb9d9855c0461a6713ab66dec9563006b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fd1476fe95ab294475313269cf367afeb212a1f03d733faf5f9233d834c4c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b0f6f01be805b6be4199b69ae9b94bffb383f9812e8db4af2f140737f23bee8"
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
