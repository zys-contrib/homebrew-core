class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.77.18.tar.gz"
  sha256 "2e9b132a5a239066839205d3debfd022cc14f4a0a07ad3cd502d6982a86f74b5"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb8c6d9d7b61771131b757a2f35d3307a54bd78968945c62817595a8ba583639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb8c6d9d7b61771131b757a2f35d3307a54bd78968945c62817595a8ba583639"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb8c6d9d7b61771131b757a2f35d3307a54bd78968945c62817595a8ba583639"
    sha256 cellar: :any_skip_relocation, sonoma:        "8321e42fb8ac8051d352842ec9bc9821c32e2caf506ff417241d3417c8d9c904"
    sha256 cellar: :any_skip_relocation, ventura:       "8321e42fb8ac8051d352842ec9bc9821c32e2caf506ff417241d3417c8d9c904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "057566a0bf8b8c69fd0f853d8bd4e42156963cc99bfedb93610e84bb9c9b31f9"
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
