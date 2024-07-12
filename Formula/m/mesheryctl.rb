class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.82",
      revision: "f66c3eff6fb942d43db9fe8a2e2fa0b0ee3522f2"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8008ebdc8a32b3fd9b995305980c79a8921d6d96c94e24bada2de559e036be8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8008ebdc8a32b3fd9b995305980c79a8921d6d96c94e24bada2de559e036be8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8008ebdc8a32b3fd9b995305980c79a8921d6d96c94e24bada2de559e036be8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "94e06e19e777350aabf623c6ddf942e0e185d6d3cb6585fe61b0b1ed5afd253c"
    sha256 cellar: :any_skip_relocation, ventura:        "94e06e19e777350aabf623c6ddf942e0e185d6d3cb6585fe61b0b1ed5afd253c"
    sha256 cellar: :any_skip_relocation, monterey:       "94e06e19e777350aabf623c6ddf942e0e185d6d3cb6585fe61b0b1ed5afd253c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da9f0dad3d44a04fcb916c1678c169f2f0dde738ad62ee1d653af7d1b2fe2a01"
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
