class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "4b9b653cf395bf087883013ddff7b2e54f1a62b9423024310a81a31b0a063d0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0564783427baa36ae51d4e34b8f4081e3d695240cfc3eeab1b3dcf6fd54589f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f97fdc26283e1b69c6595ac537861ead2dffcc1246e9e12f61cda4bcb8ce6d98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "398965dbcff19afa214705e41b11f7acb6beeb778138546792c5d007e8bd69a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "020db1f326ef85617b352b29ff50ba83dd22ea93b25512667fd7ae8823ab6b33"
    sha256 cellar: :any_skip_relocation, ventura:        "a125859efff59cd22504461bcf4c14703f6c0c76768d3a9a67d72dcf79b45dfa"
    sha256 cellar: :any_skip_relocation, monterey:       "8dd78f7ceea94d29e9ede29dba5d9a107a937ba401b0d01f83d735364002bdd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da2b8726e76eb8815ed862412e953b2b4038a646890c12088da64223c3b5c3ba"
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
