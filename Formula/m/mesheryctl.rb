class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.39",
      revision: "eaa3fd41cd57164cfd87693df0da0d1469935cdd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb1f404a180bec1ad8f7da7e0a0c51a132afd579dbc3e4dffbd090ad8a3ce0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbb1f404a180bec1ad8f7da7e0a0c51a132afd579dbc3e4dffbd090ad8a3ce0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbb1f404a180bec1ad8f7da7e0a0c51a132afd579dbc3e4dffbd090ad8a3ce0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f3d6c184000cc7ccab3e8bfeea41507b045d993193df1767287c62e41642b36"
    sha256 cellar: :any_skip_relocation, ventura:       "8f3d6c184000cc7ccab3e8bfeea41507b045d993193df1767287c62e41642b36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d4366f9295e95902ffadc1985093fbc5b3788f6ac2858323d2538b411b57cb1"
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
