class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.68.4.tar.gz"
  sha256 "60c259d787eb74fc8d442dad33e2f697ab8498970b7fc71ea3d2a3c45cd9fb6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28f9a9a7de070b7520cda3f417da155891cbd1391ab71af204b2d7aa4a1a7ca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28f9a9a7de070b7520cda3f417da155891cbd1391ab71af204b2d7aa4a1a7ca0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28f9a9a7de070b7520cda3f417da155891cbd1391ab71af204b2d7aa4a1a7ca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "99e5f61888f4c3915b49032d3d8d9d7b2c5a8eaff3191aa898915c719b0f48a9"
    sha256 cellar: :any_skip_relocation, ventura:       "99e5f61888f4c3915b49032d3d8d9d7b2c5a8eaff3191aa898915c719b0f48a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5bcf130b9653852aa7a4ab4691d2687397e5650ebef43272f156cf189bb22e2"
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
