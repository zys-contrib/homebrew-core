class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.104",
      revision: "26698dbee08d9542818f82d53dc08825f2c1487d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7cf4614ed044976e8f32d7d18758d8815c47515b59dae35e343d82de003eebf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7cf4614ed044976e8f32d7d18758d8815c47515b59dae35e343d82de003eebf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7cf4614ed044976e8f32d7d18758d8815c47515b59dae35e343d82de003eebf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2e6e0c5ebe8897a599de6bdd8dd64557613229eec04cc560fe23b041b1c528b"
    sha256 cellar: :any_skip_relocation, ventura:       "c2e6e0c5ebe8897a599de6bdd8dd64557613229eec04cc560fe23b041b1c528b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89771cd15687bf4b1f62d616584cf7223240b5f42dc5d01b3c5367725944df8f"
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
