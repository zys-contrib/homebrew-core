class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.81.2.tar.gz"
  sha256 "13392dcdf785d106d10e32eb7595d5e6ff2323c370904c8b3c5710830d635c5d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd5fff3d091dbe3448567331879465cb461bf6fcef7788607b6b084dd7bc967a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd5fff3d091dbe3448567331879465cb461bf6fcef7788607b6b084dd7bc967a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd5fff3d091dbe3448567331879465cb461bf6fcef7788607b6b084dd7bc967a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a99a1eacd600c6d85196b91e3d85694e235ea6ca0a74269f83b14b599baa26ea"
    sha256 cellar: :any_skip_relocation, ventura:       "a99a1eacd600c6d85196b91e3d85694e235ea6ca0a74269f83b14b599baa26ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d6e04a6829de25cc3212a3c3082d36eaa9082c99d54d6f46d0f7dbb131f5cc5"
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
