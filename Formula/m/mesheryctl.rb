class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.143",
      revision: "4fa3ea200cc3411335cbc3d58bfa685202c3bfaf"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66a411f5d13c7d0f784ccd1f0d4a4d1b0141dca05683c0bad6eebb9815282794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66a411f5d13c7d0f784ccd1f0d4a4d1b0141dca05683c0bad6eebb9815282794"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66a411f5d13c7d0f784ccd1f0d4a4d1b0141dca05683c0bad6eebb9815282794"
    sha256 cellar: :any_skip_relocation, sonoma:        "efa6c0dd6fe52ca922869054fbcfc6bae37898d68006c99483a95b08c5460514"
    sha256 cellar: :any_skip_relocation, ventura:       "efa6c0dd6fe52ca922869054fbcfc6bae37898d68006c99483a95b08c5460514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7327b9c8e10cbea48668ed96f5a570b990d5d7881f483d9c493793fa23b844a6"
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
