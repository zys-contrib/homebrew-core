class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.75",
      revision: "7f1945679d677d6d7baabb9bfc2cd40838a71254"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05618a459452aa51d8599d63d43348e2ecf83ea5d6cebbb7a35448c988de777e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05618a459452aa51d8599d63d43348e2ecf83ea5d6cebbb7a35448c988de777e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05618a459452aa51d8599d63d43348e2ecf83ea5d6cebbb7a35448c988de777e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b414c3737ec01d6e03b1375356a7d89b230237c333945acba863a36087ea0f70"
    sha256 cellar: :any_skip_relocation, ventura:       "b414c3737ec01d6e03b1375356a7d89b230237c333945acba863a36087ea0f70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6116a65a488706cc80b966f8043c7942527f5e0014dd6f088c5f576b3a32388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "189fcfeb3d10ecb5b47303bcbbcd300625be652ecc80edf144793dafe9ff1b9c"
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
