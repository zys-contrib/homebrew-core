class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.66.3.tar.gz"
  sha256 "76b8021185cf29bc9b3110235f41e57295855c691dd9eedfb3d14bc2ac5c94ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f98bf42d0f33746c1316b287e190920b0e89b1203bf09adcb18da285f66cc14e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "663a5b39844f1c9b65e69b67627cd2205c0e803c0190844ce4c245d5370d0f0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54af2a2729d2259d348deb5a51598ed27b26e6288c712d1aee6ee88a42f91381"
    sha256 cellar: :any_skip_relocation, sonoma:         "99b88eebedfb8f544a8b54b834e85779d5ed5aa6d2dc4260c370aca875d99eac"
    sha256 cellar: :any_skip_relocation, ventura:        "f3497caa00a2098a6a86624bbcbe47658505613561b1cf61e226a67fe4cd9868"
    sha256 cellar: :any_skip_relocation, monterey:       "683369afa001cd809913a68a53683634b67e2c1e802d92af8f762b92c9552fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a54c941c246e5354e62c5c99f92b107b337bb7d09ec6d52e688e4edde0ea8b1d"
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
