class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.73.13.tar.gz"
  sha256 "2df5fc58593bb38402f848565c611f87bfe42b0d872761efb27c6ac3b20001c3"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7d836d06830dc06b6bc642c72acb7515f8bd96acda66fbe472ac87b02902d04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7d836d06830dc06b6bc642c72acb7515f8bd96acda66fbe472ac87b02902d04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7d836d06830dc06b6bc642c72acb7515f8bd96acda66fbe472ac87b02902d04"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e3f7ab70d5fc0e273c8b2641ef8b8e0b9f3ad297260a4bcf4ab5197a5209c85"
    sha256 cellar: :any_skip_relocation, ventura:       "2e3f7ab70d5fc0e273c8b2641ef8b8e0b9f3ad297260a4bcf4ab5197a5209c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7914ab4c0d52b9d3412913547863ea67bb0ded0c2c402ae6de9001977b7544f8"
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
