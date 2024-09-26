class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.67.14.tar.gz"
  sha256 "b7c2d446f63ad2ca68617d9b9305a10b9a43a33c3ef42a63ba018961dc4e4eca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88804b6511154f913cb18296bfd4339b4379eb46d07eceb54c2cddaf4457c65f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88804b6511154f913cb18296bfd4339b4379eb46d07eceb54c2cddaf4457c65f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88804b6511154f913cb18296bfd4339b4379eb46d07eceb54c2cddaf4457c65f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a342d79af3527c6da6d9e3449728c07645aa84aa0ffedf36d2a2300317b5328b"
    sha256 cellar: :any_skip_relocation, ventura:       "a342d79af3527c6da6d9e3449728c07645aa84aa0ffedf36d2a2300317b5328b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e551842f727198b75fcc5507cff98c7f288cbe1e5d9eca3859527f93e88e146"
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
