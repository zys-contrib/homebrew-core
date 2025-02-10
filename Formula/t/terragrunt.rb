class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "5e717a3a6c9e23cedde6f2821a4c96a25e79121d267cb040ce4b1791664520c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feacb48fd325c42f8e857d6e98f6681fdb57a036edb8313dc8fa702a968d0dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feacb48fd325c42f8e857d6e98f6681fdb57a036edb8313dc8fa702a968d0dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feacb48fd325c42f8e857d6e98f6681fdb57a036edb8313dc8fa702a968d0dda"
    sha256 cellar: :any_skip_relocation, sonoma:        "a585d3b49b48e2bd840e682dd2661d33fee7d9036ef9a1b750f7bf8df1815f90"
    sha256 cellar: :any_skip_relocation, ventura:       "a585d3b49b48e2bd840e682dd2661d33fee7d9036ef9a1b750f7bf8df1815f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94f6e3f5177a15576b50e74724c7e559c194b8b932242dc8ba67cd77bd3d384"
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
