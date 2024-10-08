class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.121",
      revision: "dc65251ec979a0003fbef7a1a61a3eb76cb3f040"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f698fc98172dd1a3e5142e76e0b2db1579d03e4d195fbcd923c27183c1be756a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f698fc98172dd1a3e5142e76e0b2db1579d03e4d195fbcd923c27183c1be756a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f698fc98172dd1a3e5142e76e0b2db1579d03e4d195fbcd923c27183c1be756a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3130ed444bf1f4226706bbfc06a074cd6d46978d8c746857d51dd6fdc89d73f"
    sha256 cellar: :any_skip_relocation, ventura:       "c3130ed444bf1f4226706bbfc06a074cd6d46978d8c746857d51dd6fdc89d73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6e71f30f88f55e0b3e664b6cef9d9158c2bbe294f916f1c8c28e46486a511d5"
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
