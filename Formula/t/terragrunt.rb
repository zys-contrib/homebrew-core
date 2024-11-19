class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.68.16.tar.gz"
  sha256 "3a4a3440d66ec71b77178685181aa355a23532e1e4983b6a0b7e7f8906c27507"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbc26a08d5a24c63380afd32d5da05d517ac8931b741cb682b85e7f132acd57c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbc26a08d5a24c63380afd32d5da05d517ac8931b741cb682b85e7f132acd57c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbc26a08d5a24c63380afd32d5da05d517ac8931b741cb682b85e7f132acd57c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f52be8942459de59d215916cdffe1bb9ac6dc71150b21578a41a698aebc62e98"
    sha256 cellar: :any_skip_relocation, ventura:       "f52be8942459de59d215916cdffe1bb9ac6dc71150b21578a41a698aebc62e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4f65f657b63e41da63273088605edcf69d34b99b160758cc3f2142b329dc853"
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
