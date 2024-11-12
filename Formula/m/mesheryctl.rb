class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.146",
      revision: "b79d64123b49476209fcb7617f4c006aab290940"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35271fc4a7352a5deb5404dace6031bd74e82e17b746ffd37483e6be64ddbe4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35271fc4a7352a5deb5404dace6031bd74e82e17b746ffd37483e6be64ddbe4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35271fc4a7352a5deb5404dace6031bd74e82e17b746ffd37483e6be64ddbe4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "66d00c77afdde466bd17e271a3994201053a59c1d6f3866d9e9c445704aa692b"
    sha256 cellar: :any_skip_relocation, ventura:       "66d00c77afdde466bd17e271a3994201053a59c1d6f3866d9e9c445704aa692b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46eccd39de8e14419dd45f208b54eb846cbe6afe00f8c72cedcb820b30379dfd"
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
