class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.12",
      revision: "ed97fe187603dcdbc99b08075dba37b315a05544"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63ad9016312b70b52c135ebd6c549176e465ceaf96c91af29a4a9482f0de76df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63ad9016312b70b52c135ebd6c549176e465ceaf96c91af29a4a9482f0de76df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63ad9016312b70b52c135ebd6c549176e465ceaf96c91af29a4a9482f0de76df"
    sha256 cellar: :any_skip_relocation, sonoma:        "93550ccb26c83b0478223972f994e9b89bed0f45213ddc3a5e3cc4e3fa50dc60"
    sha256 cellar: :any_skip_relocation, ventura:       "93550ccb26c83b0478223972f994e9b89bed0f45213ddc3a5e3cc4e3fa50dc60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b64514ba60afb983b15f6680f9650c066d1a2c1c049b79f517ec0e3f81f8b09"
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
