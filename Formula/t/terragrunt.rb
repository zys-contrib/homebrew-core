class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.73.5.tar.gz"
  sha256 "0e27273f24f3e9096f733e9f64dba176a0c64e54cee69ca6056b5ecbff2a138d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "987a88457e17ebdc8121c49f8d12018a2f82697f88d43fe60860fa4b1672b634"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "987a88457e17ebdc8121c49f8d12018a2f82697f88d43fe60860fa4b1672b634"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "987a88457e17ebdc8121c49f8d12018a2f82697f88d43fe60860fa4b1672b634"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7f26fe375bea2ddea96751c8f9537119ffb1a2221a5d76eaa3d78790a01cf91"
    sha256 cellar: :any_skip_relocation, ventura:       "f7f26fe375bea2ddea96751c8f9537119ffb1a2221a5d76eaa3d78790a01cf91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "870c9b34c7770f3a32efd32bd35157c2d89ffd0b30744511bc86e3b0816f6301"
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
