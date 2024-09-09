class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.67.4.tar.gz"
  sha256 "b144e620bc253bb84b76889a726bbe5dd0b5e648460a75e0043dc7dd2b4fc964"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d0d2b75f5289b44e5181e800bde21fb0300b796fd8dffcdc60c52855355a793"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d0d2b75f5289b44e5181e800bde21fb0300b796fd8dffcdc60c52855355a793"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d0d2b75f5289b44e5181e800bde21fb0300b796fd8dffcdc60c52855355a793"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e635039d5e667213f75dde604846bedb1bb8a89da34053fac2790fdfc09c4ae"
    sha256 cellar: :any_skip_relocation, ventura:        "8e635039d5e667213f75dde604846bedb1bb8a89da34053fac2790fdfc09c4ae"
    sha256 cellar: :any_skip_relocation, monterey:       "8e635039d5e667213f75dde604846bedb1bb8a89da34053fac2790fdfc09c4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e6c5b9d125b2df3dfff9100bd439c6a1d1d602ae9a4cca4f83d0dfdf67883a"
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
