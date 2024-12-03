class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.69.6.tar.gz"
  sha256 "773afd1eaf1311fe63bfc766c5858049ac43752ef11ed2fc2f6084bb46f6e2c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b28d6c71bfbc4ecfea68256483f082efdd78f4dd76167d6e65cfe1b9519e162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b28d6c71bfbc4ecfea68256483f082efdd78f4dd76167d6e65cfe1b9519e162"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b28d6c71bfbc4ecfea68256483f082efdd78f4dd76167d6e65cfe1b9519e162"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa453e55211724e74a26ef37d260eaf26f3b325a4b638d12dc3bca2512f133d7"
    sha256 cellar: :any_skip_relocation, ventura:       "fa453e55211724e74a26ef37d260eaf26f3b325a4b638d12dc3bca2512f133d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7727e03c14ea695b30f2b60e70d2aa29695020d6dacc104e217d805b6bc16ec"
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
