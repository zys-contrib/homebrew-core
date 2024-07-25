class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.63.7.tar.gz"
  sha256 "8d678f195c4ce7b18dce23b643104ec15cf669345cf4c67b08fd6885cb5a9e21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "469cb6016437e9f79bd882426cb23c7727152c349b44deaf591f5e7f158b97ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4dc8f57bb2695761de8b4b9ec656b944f9f34c22ce3bb272d41ce97035f9a6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f35af3a3861f9fd9e881516d1e3e72f2b83cc8acdacd84a6adca397e3fae9e61"
    sha256 cellar: :any_skip_relocation, sonoma:         "62e28e49d7f338a7f7e1ecad1f24adfa12275d0fb8f8083f55f4a913de123a49"
    sha256 cellar: :any_skip_relocation, ventura:        "bdb14d7e4d236dce4de2e62a6d724a8d3ac6c95add7a0900a7e354a2f882a407"
    sha256 cellar: :any_skip_relocation, monterey:       "1e7c4638e913b9a498351078d22cc9d445c46f5154a99fd918024e6625ea4e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa81074c2639fe2fde9862d4b655045967381c7b5c773f0c745029c96e8c00c4"
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
