class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.72.8.tar.gz"
  sha256 "5db2c906f4953bb83c4079d517046856718df872be70423709d607131402e739"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feea43fd13653d5ccb5f4fbffd53f9c7cdec501f4cf92ff283968b77700c0ddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feea43fd13653d5ccb5f4fbffd53f9c7cdec501f4cf92ff283968b77700c0ddb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feea43fd13653d5ccb5f4fbffd53f9c7cdec501f4cf92ff283968b77700c0ddb"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ab801177b32035941ca3228ebf4e0a74ab4ace38a82630e64ce29b88453d3e0"
    sha256 cellar: :any_skip_relocation, ventura:       "0ab801177b32035941ca3228ebf4e0a74ab4ace38a82630e64ce29b88453d3e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f8f6e8bac5ce185478ae1c9ef2adec9ce2799e91e90217ab8b66f22b2d20c2a"
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
