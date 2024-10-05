class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.114",
      revision: "366a434ec4403acb450f0c45de8e950d8fee4162"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7588c06c506d8b437c06db785ad7350be723711d254f46ad670e7d51696d699"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7588c06c506d8b437c06db785ad7350be723711d254f46ad670e7d51696d699"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7588c06c506d8b437c06db785ad7350be723711d254f46ad670e7d51696d699"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec07df918e252bf9649cf985ded88ff8591e6aff99a71a7e6ce36ab56a450a8c"
    sha256 cellar: :any_skip_relocation, ventura:       "ec07df918e252bf9649cf985ded88ff8591e6aff99a71a7e6ce36ab56a450a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b69fd23d4abf3e9b1ccce14b4a5d89598ff74b1ea502222348009145643a21af"
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
