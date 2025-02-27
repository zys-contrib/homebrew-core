class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.40",
      revision: "510c3c109739ab2082efd167b41df1ee59592d82"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24cdfde983dc4d7855c9b0fbb434c6a10e3ca02f430dff885f4637a4ed66d0d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24cdfde983dc4d7855c9b0fbb434c6a10e3ca02f430dff885f4637a4ed66d0d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24cdfde983dc4d7855c9b0fbb434c6a10e3ca02f430dff885f4637a4ed66d0d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd581da2518865d2f211a1cac466f84433b7744e059de0392d65d71ae6f85778"
    sha256 cellar: :any_skip_relocation, ventura:       "cd581da2518865d2f211a1cac466f84433b7744e059de0392d65d71ae6f85778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46e47be25a7e370df39606d88071e8d13f0b4491fb085d631586c0ffa86815d3"
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
