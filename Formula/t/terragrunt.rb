class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.77.3.tar.gz"
  sha256 "f4f5288c242036d704bf2b7d24f4df2639928f7003db56ebdf7e8151a79c3283"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f37d1d3f9f343826fc47c84acbf3844d0bc3f00c596a778aea078abad6b4b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f37d1d3f9f343826fc47c84acbf3844d0bc3f00c596a778aea078abad6b4b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78f37d1d3f9f343826fc47c84acbf3844d0bc3f00c596a778aea078abad6b4b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "56440510c2d9faffc6d1e5c4bf9817de0b414fd8619f4fa3a8a79c6aea004dcf"
    sha256 cellar: :any_skip_relocation, ventura:       "56440510c2d9faffc6d1e5c4bf9817de0b414fd8619f4fa3a8a79c6aea004dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76bf6bd19e02f4f41bd23838f3f888ec4d5d45586e75d37cb9def16c87a77382"
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
