class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.112",
      revision: "ee9536b27a66078a23997ecd0368f3e7305d3143"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaa9c3c50fa32ea12388493f269dde5a83f6c5d079096648f42b8bfbc043a68e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaa9c3c50fa32ea12388493f269dde5a83f6c5d079096648f42b8bfbc043a68e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eaa9c3c50fa32ea12388493f269dde5a83f6c5d079096648f42b8bfbc043a68e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0a6efb49e95148d1b82627fffb917a0bc4251513810555dcf6aa9a54979c8b7"
    sha256 cellar: :any_skip_relocation, ventura:       "d0a6efb49e95148d1b82627fffb917a0bc4251513810555dcf6aa9a54979c8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ca244038229b2d3ec90ea6cee2d8ba90a9583a1eb199b8d2d83755d5df1043"
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
