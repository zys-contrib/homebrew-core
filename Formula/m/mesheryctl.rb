class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.22",
      revision: "3debded21f182c5cd740dd2b8169bcfd2bcfb076"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6ae6580db36117e9b32a59a98f4a69aac93c3b21462e84dc8cf6b01ec8147d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6ae6580db36117e9b32a59a98f4a69aac93c3b21462e84dc8cf6b01ec8147d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6ae6580db36117e9b32a59a98f4a69aac93c3b21462e84dc8cf6b01ec8147d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b89e241aac55ae1a543212e16403a429672feae34acd48d80a69224ae1988b3c"
    sha256 cellar: :any_skip_relocation, ventura:       "b89e241aac55ae1a543212e16403a429672feae34acd48d80a69224ae1988b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29efdaf66148d12cf727413e64de269cd6aab2439825b018a666c0f3ccda0ed0"
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
