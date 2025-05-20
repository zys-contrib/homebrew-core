class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.84",
      revision: "6d8b8d6652476b476c394fb3fff052f209ee0868"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f446cc42c3469e3427cb659d6d344c6f1b4c19bd0ce723c0e9b6e023bba8479"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f446cc42c3469e3427cb659d6d344c6f1b4c19bd0ce723c0e9b6e023bba8479"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f446cc42c3469e3427cb659d6d344c6f1b4c19bd0ce723c0e9b6e023bba8479"
    sha256 cellar: :any_skip_relocation, sonoma:        "1aef26596896665eeb47ddd1e0fa5c84d074b9f6d9895fb74ef7a25321e0b945"
    sha256 cellar: :any_skip_relocation, ventura:       "1aef26596896665eeb47ddd1e0fa5c84d074b9f6d9895fb74ef7a25321e0b945"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c354785c362bd7a57ce0f61579f7a990d2806f928ab4ad93057057c377085e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d0f17a80349725e039ae9f3bf1da7ba67889b735f9c0d658e12e044d479e550"
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
