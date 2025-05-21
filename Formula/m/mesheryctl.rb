class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.85",
      revision: "150994296a53f5c26a1e2935c9cd379ca7b4cb5a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04adce8e03035d1e2d5a4592d71f3e3d93e8c8a0fe091cdc3fc9ec4a64a0395a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04adce8e03035d1e2d5a4592d71f3e3d93e8c8a0fe091cdc3fc9ec4a64a0395a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04adce8e03035d1e2d5a4592d71f3e3d93e8c8a0fe091cdc3fc9ec4a64a0395a"
    sha256 cellar: :any_skip_relocation, sonoma:        "83f4b5fd8d1a6417bc7d3736b04e02d89951632090b47f7fb5587315247fa469"
    sha256 cellar: :any_skip_relocation, ventura:       "83f4b5fd8d1a6417bc7d3736b04e02d89951632090b47f7fb5587315247fa469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9975e659f0e3821b771557f25b46d6477805235ebddcb65d16ae6e978f151b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2314a9b461a779704a37df4affe09f73acf1f662bef9460b1f7bdb933879d2f2"
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
