class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.142",
      revision: "a411fcefff8f8e5d6e4bd9e4f214190f84210f78"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a0d7ad5c9c94bd93aabcb378348542de525cae912e6f0be8f8354389307f69d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a0d7ad5c9c94bd93aabcb378348542de525cae912e6f0be8f8354389307f69d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a0d7ad5c9c94bd93aabcb378348542de525cae912e6f0be8f8354389307f69d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b58c4f108a62589ae3cb87891d1dcc2af2cd534e684dd2a44010dbab4cfe4a8"
    sha256 cellar: :any_skip_relocation, ventura:       "8b58c4f108a62589ae3cb87891d1dcc2af2cd534e684dd2a44010dbab4cfe4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad4e30390af5a73e8c8b4de3a9bf68408c29f31b4dd361d14a3920045fe338b"
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
