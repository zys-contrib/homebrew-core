class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.67",
      revision: "088b28e244e31ab316d72fa0a79c4878932c4a79"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ac8087920d2ddb36c429555d350b89affcc5327947a3e775f03ff240e12b190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ac8087920d2ddb36c429555d350b89affcc5327947a3e775f03ff240e12b190"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ac8087920d2ddb36c429555d350b89affcc5327947a3e775f03ff240e12b190"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fdffe01bc43482e93c34ea4d411541f49c9538e1b877c016994c372aac56730"
    sha256 cellar: :any_skip_relocation, ventura:       "7fdffe01bc43482e93c34ea4d411541f49c9538e1b877c016994c372aac56730"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c231597a9af07a8d2ec4f016087b9132ea3ac66cd6cc0a88f51205b58842cfc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc461330cadb313d691f14128b4f43523adee32e3da14cab3dc866122be60f6"
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
