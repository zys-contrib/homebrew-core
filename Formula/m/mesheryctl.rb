class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.127",
      revision: "8bbd75e4325bd8760bb162f7619c8d771d29f609"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "028db55d43880d0daf366df2ae82fbd5244526af19fe17d85c72416ddc4ae8ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "028db55d43880d0daf366df2ae82fbd5244526af19fe17d85c72416ddc4ae8ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "028db55d43880d0daf366df2ae82fbd5244526af19fe17d85c72416ddc4ae8ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9de4a86ce971e7d9715646bc9605c26950abba924521364da810e072849abc3"
    sha256 cellar: :any_skip_relocation, ventura:       "a9de4a86ce971e7d9715646bc9605c26950abba924521364da810e072849abc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef77625f460887013481421c3811bff7fa43f33a758011a06b9ebc052cabafbc"
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
