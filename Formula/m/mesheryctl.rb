class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.87",
      revision: "3b7410fabb9843ccaa547a489b8b4ac5a1204e73"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f7c0b4e1f1b4c59e24dd683a05cbf1f7a0aa5179d8e8beeb6bdc089d84be0b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f7c0b4e1f1b4c59e24dd683a05cbf1f7a0aa5179d8e8beeb6bdc089d84be0b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f7c0b4e1f1b4c59e24dd683a05cbf1f7a0aa5179d8e8beeb6bdc089d84be0b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fdfebdd36391f64291c7214de080ee3c3979cc94d3440e10fa8793f66fd2549"
    sha256 cellar: :any_skip_relocation, ventura:        "0fdfebdd36391f64291c7214de080ee3c3979cc94d3440e10fa8793f66fd2549"
    sha256 cellar: :any_skip_relocation, monterey:       "0fdfebdd36391f64291c7214de080ee3c3979cc94d3440e10fa8793f66fd2549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb082d26694316ef5c6afd2ad45bf5ed0c7550e73495b1e56c68a3e470d74bf4"
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
