class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.78.3.tar.gz"
  sha256 "dc8c21e17e7014e4e6afdd40279284654bc241a741c7528c03c32d80e0a94c84"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e167f3b713e51456d6bf75c248b604edacf1db96197114c88cded7c47c67c38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e167f3b713e51456d6bf75c248b604edacf1db96197114c88cded7c47c67c38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e167f3b713e51456d6bf75c248b604edacf1db96197114c88cded7c47c67c38"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aa79a804e3390c6bbfc413a88db72bcddfd8487119c0447e483c9c0ea700304"
    sha256 cellar: :any_skip_relocation, ventura:       "4aa79a804e3390c6bbfc413a88db72bcddfd8487119c0447e483c9c0ea700304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1343e29660723fb5cd7100bb4bb5b523f1db242b5327d964296d29d5a6f4253f"
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
