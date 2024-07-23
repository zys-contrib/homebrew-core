class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.63.4.tar.gz"
  sha256 "b7cfb88b47a1c5f64d3b74a7e3f56d8fee12a53fa4c13e5a94a45f73b53b1b4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b592314bbade5b1d102c71dc8b5a85cfd9d08ea44ef380e8b1ebb11aaef0f9be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68ec905aec3d1b76b9829e153f387fb4e70786014dd8013bd320ce51aa020c0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5139ac74c36bc18abecf57fb4b42e4f0108ef554c2ab17b928f120736324f158"
    sha256 cellar: :any_skip_relocation, sonoma:         "103de7786ee4547f592a54c08b460dd401168a3553737e052057d70474cac128"
    sha256 cellar: :any_skip_relocation, ventura:        "ff32c01eeb22c262d579021b71b9682c1b61d24b3f8b92f77bacee686adc0f88"
    sha256 cellar: :any_skip_relocation, monterey:       "363f3ea7f028640d62e6e324837245b0926e47886c29ab0307bb5afecbda8d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99698f66bc112e0301db150c5c91c165d12a3a7a325f27dc1bf1e7ce99bb7c2e"
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
