class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.67.16.tar.gz"
  sha256 "3d9bd791fb47dfc1b4dd9c8748e5a1543cbba634fc9b75b3674f3d57238fbe3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6838f4ce8908cd1e693cfe898327073ef213781f08cb44fa3486a4462a5ba05e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6838f4ce8908cd1e693cfe898327073ef213781f08cb44fa3486a4462a5ba05e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6838f4ce8908cd1e693cfe898327073ef213781f08cb44fa3486a4462a5ba05e"
    sha256 cellar: :any_skip_relocation, sonoma:        "29b9a49c806fa3e8a074735ad6a911814bb7a82e0f385f49225a20136f5a4b0e"
    sha256 cellar: :any_skip_relocation, ventura:       "29b9a49c806fa3e8a074735ad6a911814bb7a82e0f385f49225a20136f5a4b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f7796b1e08eb58dfe215e3416e7aa837630e8261212cf61b6ac2d4f6b2a7b25"
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
