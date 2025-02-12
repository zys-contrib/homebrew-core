class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.52.2.tar.gz"
  sha256 "e02105fa240a551780563f438d97f53ee7e33159332a6a541d0b03500148fc2a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cdbe3e96471f4733295066c9aa3c34f47d6aff13b5587355c05cf0cf7a35518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cdbe3e96471f4733295066c9aa3c34f47d6aff13b5587355c05cf0cf7a35518"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cdbe3e96471f4733295066c9aa3c34f47d6aff13b5587355c05cf0cf7a35518"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fbdd41ce4937ad899474054842e9aa0819d221d32953b6f3df64d49049fa068"
    sha256 cellar: :any_skip_relocation, ventura:       "9fbdd41ce4937ad899474054842e9aa0819d221d32953b6f3df64d49049fa068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a5afc8d499310171fd62956710a29cf163dbddfaecf923157ea7251ae7e58a"
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
