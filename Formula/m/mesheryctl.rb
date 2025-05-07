class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.74",
      revision: "4597589757fae7d3675d37741529224e2040e29b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a308da8a34c23f3df305e6e07c48a6df7f193033cf43cf2c0418dfcc68fb8726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a308da8a34c23f3df305e6e07c48a6df7f193033cf43cf2c0418dfcc68fb8726"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a308da8a34c23f3df305e6e07c48a6df7f193033cf43cf2c0418dfcc68fb8726"
    sha256 cellar: :any_skip_relocation, sonoma:        "687ac09bbd1d3107b330f7b6cb30a4607af40efc664ad5cb69117f0b28656827"
    sha256 cellar: :any_skip_relocation, ventura:       "687ac09bbd1d3107b330f7b6cb30a4607af40efc664ad5cb69117f0b28656827"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8cf931411df3654a376f4aa1a9c37d3e2de0af4d9ddaef2fce39c270e6b18e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "271d6420004f9d51683e11d11ca2ac02c12aa2d6de57fa6f20f1a0b39e5180e3"
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
