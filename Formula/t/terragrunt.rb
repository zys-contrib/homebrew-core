class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.69.3.tar.gz"
  sha256 "08c4369d3d89c1e8355a4f6261af2555e297f17e0a683c676d8698c4c961c4b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e9e82f349cb73fdd9919fe388612a796efa3eca494f33ebdbeb601f270f6939"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e9e82f349cb73fdd9919fe388612a796efa3eca494f33ebdbeb601f270f6939"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e9e82f349cb73fdd9919fe388612a796efa3eca494f33ebdbeb601f270f6939"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc5438e69dcd49a0788c6cb40e67186a4742cd1da5eb6e61d84a0731cb425c68"
    sha256 cellar: :any_skip_relocation, ventura:       "fc5438e69dcd49a0788c6cb40e67186a4742cd1da5eb6e61d84a0731cb425c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e39c00fd21f98990eb7f4fb033172c98fae4215652247cda94a64eb909ee015"
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
