class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.75.8.tar.gz"
  sha256 "7ee235d51f33bdaa43afd81b95d5f30b9b94a68a8e3dc7fc579ed12a334bad70"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "395edb6187c10a2b3c88e867bf74c5f66ccb434843713ae21e17316de886312d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "395edb6187c10a2b3c88e867bf74c5f66ccb434843713ae21e17316de886312d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "395edb6187c10a2b3c88e867bf74c5f66ccb434843713ae21e17316de886312d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a69d6f79c9b722f012bbd050ff89e1b4cf2cb7da4c2d8b427dd0f9d00bae2f79"
    sha256 cellar: :any_skip_relocation, ventura:       "a69d6f79c9b722f012bbd050ff89e1b4cf2cb7da4c2d8b427dd0f9d00bae2f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ec60f5ac972c076d83f74ffa323f23de438ea39a187790ef66f892e4fcfa758"
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
