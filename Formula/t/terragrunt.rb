class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.71.4.tar.gz"
  sha256 "9614da5c29a775f702bcacad007ba6bb2be1da8fefa119792566a1f68b4b5f66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70706ac6d0aa1f1cff1abbda19245a97247a95a9c091baea7a8b3a8ae5ea1926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70706ac6d0aa1f1cff1abbda19245a97247a95a9c091baea7a8b3a8ae5ea1926"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70706ac6d0aa1f1cff1abbda19245a97247a95a9c091baea7a8b3a8ae5ea1926"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad3f389f59b748e412f51767c59cc32d28f646d734e8ab3702e20a9f36f9b6cd"
    sha256 cellar: :any_skip_relocation, ventura:       "ad3f389f59b748e412f51767c59cc32d28f646d734e8ab3702e20a9f36f9b6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db0ca73886bf395df514727e8f01001a7b4e4dc3bff6109c525a9b0fc0a42315"
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
