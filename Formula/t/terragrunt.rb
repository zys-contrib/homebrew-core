class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.74.0.tar.gz"
  sha256 "690ddfbb14df10734a86e67997e3681b828fd3a54135e89954d19ebef1b03daf"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df113afcfe94bd69cc835ee03626acdd1d0d335ec4cc53f477d20fb76eee9988"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df113afcfe94bd69cc835ee03626acdd1d0d335ec4cc53f477d20fb76eee9988"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df113afcfe94bd69cc835ee03626acdd1d0d335ec4cc53f477d20fb76eee9988"
    sha256 cellar: :any_skip_relocation, sonoma:        "12f0069c836fa8a62a83d735170456faff09f001725a210354fd1760cbb935c7"
    sha256 cellar: :any_skip_relocation, ventura:       "12f0069c836fa8a62a83d735170456faff09f001725a210354fd1760cbb935c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a85299aacfbbb8878ec955fd62998171d7b174e7c35cda46a994ea88a616bdc"
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
