class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.79.3.tar.gz"
  sha256 "1564273276f49ce5962b167b79f37f071d5d67e4a464cc6832c8a73a5d09da4c"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1f5aaa1d815e7ca2982ecaae63b2c3b7ebff7b79ff48a7f885b4953c10680a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1f5aaa1d815e7ca2982ecaae63b2c3b7ebff7b79ff48a7f885b4953c10680a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1f5aaa1d815e7ca2982ecaae63b2c3b7ebff7b79ff48a7f885b4953c10680a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bdcf9c8897ae0a9b6538f4eab21f3fd048bfffe40bb4259ac6c41580709d056"
    sha256 cellar: :any_skip_relocation, ventura:       "9bdcf9c8897ae0a9b6538f4eab21f3fd048bfffe40bb4259ac6c41580709d056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5602ff55c811f4e8d623ed0e88acfb7b46920c6e1d507fc2538fbd6e4aefdf2d"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
