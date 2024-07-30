class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.64.3.tar.gz"
  sha256 "11be31943e281502a0b023199fac9d38542c96165b843ab69230f51667890fe3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbfcadc47450eab822be2d51b60a000447a2f9eaaef135993f8cb11a4aba9707"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d89bdc8e3003a1173adb6bd38bd32902cf7764392f7eef776b406082e69c45f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e87911abc0466fb1e7452e1acd75f4074c30060883c5a1d3ea2aed2390be5c63"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf448e0d75146412a65458943e5b888b179d3eb4ba0f6611e363edd07dbabecc"
    sha256 cellar: :any_skip_relocation, ventura:        "edc33f32d7bf0aad91f499cdf893770486f0d64d9a9bdbd4e93071ae2f4f7827"
    sha256 cellar: :any_skip_relocation, monterey:       "ed1757816798db09074a9718cdbd8a1e648a23f26261bcb5f37d89ce64e51a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83f708d76cc7697d9d4e0b4aab7e2df0eabcc171248faa74eb51377a90e9d5fe"
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
