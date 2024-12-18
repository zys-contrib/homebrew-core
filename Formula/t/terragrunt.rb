class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.70.3.tar.gz"
  sha256 "b857bee8c007f54a5a7f73f2ce68f07c87b9e0578203d75d1b8478a3467952a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bca72138b53de24b895857b94eaebe1a268b63796c2a57e57a06a33f03e11bbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bca72138b53de24b895857b94eaebe1a268b63796c2a57e57a06a33f03e11bbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bca72138b53de24b895857b94eaebe1a268b63796c2a57e57a06a33f03e11bbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b330fe53cb86c193edec25901902c4e8e29af93b0ba23fcecebb010dbbee5b82"
    sha256 cellar: :any_skip_relocation, ventura:       "b330fe53cb86c193edec25901902c4e8e29af93b0ba23fcecebb010dbbee5b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f55314803e50592d4a60b77069451aae6b5fc23cf9abe71a93708fd4c2d1a87c"
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
