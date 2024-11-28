class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.164",
      revision: "9e1927d15275b4f8cd349bef13efa516a3062135"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3601e124c7149f99f9d68e92bfcd2e12adea399228f9d23cc20ee62d8cfc0951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3601e124c7149f99f9d68e92bfcd2e12adea399228f9d23cc20ee62d8cfc0951"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3601e124c7149f99f9d68e92bfcd2e12adea399228f9d23cc20ee62d8cfc0951"
    sha256 cellar: :any_skip_relocation, sonoma:        "62e8b26bc048dd489b37bbf2eac783e7b6fe645f9cd1701bb6e8eaa6b3d424b8"
    sha256 cellar: :any_skip_relocation, ventura:       "62e8b26bc048dd489b37bbf2eac783e7b6fe645f9cd1701bb6e8eaa6b3d424b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "748e6c3a405473ace21fedb6b80bca6b138dbd5bc1d7d79335a747a2b471fb47"
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
