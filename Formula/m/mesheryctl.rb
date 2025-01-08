class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.7",
      revision: "8f974c8d560448de83c40d94533c286f03e685a5"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a923c623134e2037046bc97c467e04de705c88993209f9294a8df8352d0dbec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a923c623134e2037046bc97c467e04de705c88993209f9294a8df8352d0dbec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a923c623134e2037046bc97c467e04de705c88993209f9294a8df8352d0dbec"
    sha256 cellar: :any_skip_relocation, sonoma:        "048e709471345f4b3b1babd847d7054bb94ed9515e3d05d48a2a5aade71744a3"
    sha256 cellar: :any_skip_relocation, ventura:       "048e709471345f4b3b1babd847d7054bb94ed9515e3d05d48a2a5aade71744a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "462b369a8981d38caa520b28fb3f4146b8d8b566aaf7e4f435cbbdd16e661eca"
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
