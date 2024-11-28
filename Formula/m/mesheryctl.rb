class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.163",
      revision: "86db00dff2499d05f129984261303cb213ba2e0a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67fc4b9881782aedd7c42e2cec8ffaa26f76140555520c7ffacc0191ddc96105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67fc4b9881782aedd7c42e2cec8ffaa26f76140555520c7ffacc0191ddc96105"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67fc4b9881782aedd7c42e2cec8ffaa26f76140555520c7ffacc0191ddc96105"
    sha256 cellar: :any_skip_relocation, sonoma:        "71b2bc96ad8f16a25a52de814230ef5e581630edcffe04ea2dd04dac39ff46cc"
    sha256 cellar: :any_skip_relocation, ventura:       "71b2bc96ad8f16a25a52de814230ef5e581630edcffe04ea2dd04dac39ff46cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a2d54a05d4160b146737a270713ec2e5f1500195f6b4d59778004053b5f50be"
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
