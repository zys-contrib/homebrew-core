class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.72.9.tar.gz"
  sha256 "6ba1d7454c10d5166130ae4776f84c48822df0d5f68a135fde3e3b94cefefb2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24f1b0eaf0d7a34d992888af3ba80ecc73c80ad4a112827c753024fd0cf6708c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24f1b0eaf0d7a34d992888af3ba80ecc73c80ad4a112827c753024fd0cf6708c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24f1b0eaf0d7a34d992888af3ba80ecc73c80ad4a112827c753024fd0cf6708c"
    sha256 cellar: :any_skip_relocation, sonoma:        "de61ef585637b707fec9e2abe6547dc98584c1da34b38c633de4e27e3c2e17de"
    sha256 cellar: :any_skip_relocation, ventura:       "de61ef585637b707fec9e2abe6547dc98584c1da34b38c633de4e27e3c2e17de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7f1d0898a584b798ce1a723eddf2aeec8f1c18e61a457847f6de22758b36017"
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
