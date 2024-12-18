class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "087c0c8ec4bf9155eaf74f3b2e06f1aa0564d2f9e273e93a139b687878a2b385"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccfe164f12faf8c71d97b49b2296920201478613f73de17b148095ad47a15a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccfe164f12faf8c71d97b49b2296920201478613f73de17b148095ad47a15a80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccfe164f12faf8c71d97b49b2296920201478613f73de17b148095ad47a15a80"
    sha256 cellar: :any_skip_relocation, sonoma:        "80ec160c4757b0507467e463fe70f1de00e24e8ed6840532e38bfa20e912cc7c"
    sha256 cellar: :any_skip_relocation, ventura:       "80ec160c4757b0507467e463fe70f1de00e24e8ed6840532e38bfa20e912cc7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c3c7883f6b5f1d9a832a70e1e0eda223afecd3ab7d8559ebe9a315ee4e343c"
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
