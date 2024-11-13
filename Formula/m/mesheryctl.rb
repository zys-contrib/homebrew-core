class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.149",
      revision: "7983125ff7f53692eadef3aa1de429b5b47e14fa"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b33fe1e34e56d6eb9a562d326567b25b16a2f45e71e2793eadea968be663a245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b33fe1e34e56d6eb9a562d326567b25b16a2f45e71e2793eadea968be663a245"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b33fe1e34e56d6eb9a562d326567b25b16a2f45e71e2793eadea968be663a245"
    sha256 cellar: :any_skip_relocation, sonoma:        "de73666a04e264cea20f5c1e23e64b0b5bee6a09b7d0517b6163def1d937f9c6"
    sha256 cellar: :any_skip_relocation, ventura:       "de73666a04e264cea20f5c1e23e64b0b5bee6a09b7d0517b6163def1d937f9c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbafd78c7b7312c4a49e281db7b03514f2bca43ecbaebd0bb66ba34f5275a8b2"
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
