class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.16",
      revision: "a50d87da74189fbc4482be1177bb933651351b77"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a6eeac2c0b75dc02fb897b076fa794043b0061af041e23daa6cc8c1b2db8b87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a6eeac2c0b75dc02fb897b076fa794043b0061af041e23daa6cc8c1b2db8b87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a6eeac2c0b75dc02fb897b076fa794043b0061af041e23daa6cc8c1b2db8b87"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3d5886c8fa2b99055af41e5c777141ead96a796bd20e62b6990a8656f354674"
    sha256 cellar: :any_skip_relocation, ventura:       "a3d5886c8fa2b99055af41e5c777141ead96a796bd20e62b6990a8656f354674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a550a74b3debe4896924bed104743085f0a19e7267844b3ad8df67f68379ef6"
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
