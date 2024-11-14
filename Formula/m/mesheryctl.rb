class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.150",
      revision: "6a59c3c04fdf15619ad0e87d0b2559e9fc1e60f8"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0351ff8437ade75005903849c207493cb99ae4f59ba3f9bbf4461a08e0f26d9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0351ff8437ade75005903849c207493cb99ae4f59ba3f9bbf4461a08e0f26d9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0351ff8437ade75005903849c207493cb99ae4f59ba3f9bbf4461a08e0f26d9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5fad29eba11d04795d5a06780b030c6d4387be12aa754760c3dddadd594c62d"
    sha256 cellar: :any_skip_relocation, ventura:       "e5fad29eba11d04795d5a06780b030c6d4387be12aa754760c3dddadd594c62d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70af5dfc30d88011ed61f6702a706dd42c4badbf8755f29409ddf2289e900513"
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
