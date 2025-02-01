class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.52.1.tar.gz"
  sha256 "1bc8127b4df281d692c58ca3d10167fad759ca5796e88d4e2c84aed02aed18cd"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "907159ef05b2979e146635495aab5251a3cf67f754aba647a7d3f6246f0fc6f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "907159ef05b2979e146635495aab5251a3cf67f754aba647a7d3f6246f0fc6f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "907159ef05b2979e146635495aab5251a3cf67f754aba647a7d3f6246f0fc6f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "354c46ac886ea7a91c68e2cf713db3a85a303363b9eefb010bcb57c4975d86f7"
    sha256 cellar: :any_skip_relocation, ventura:       "354c46ac886ea7a91c68e2cf713db3a85a303363b9eefb010bcb57c4975d86f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7e06734d16775400161ff9eaeac070a185905f2199f501bff6479acfaf9860f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
