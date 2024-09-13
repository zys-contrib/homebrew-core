class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.67.5.tar.gz"
  sha256 "246994c904bbc7ad365cd2b023ea3077bf1e1b14f57821df2d61a079bc75b9a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4d8f3884b101c8564ea32b3071e1b6349100e1619287ddb688239956e043f9cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d8f3884b101c8564ea32b3071e1b6349100e1619287ddb688239956e043f9cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d8f3884b101c8564ea32b3071e1b6349100e1619287ddb688239956e043f9cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d8f3884b101c8564ea32b3071e1b6349100e1619287ddb688239956e043f9cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "d74bf12c450feed0d0cc30ea15b206fdc95b578b22d65eb29993ddd41d584428"
    sha256 cellar: :any_skip_relocation, ventura:        "d74bf12c450feed0d0cc30ea15b206fdc95b578b22d65eb29993ddd41d584428"
    sha256 cellar: :any_skip_relocation, monterey:       "d74bf12c450feed0d0cc30ea15b206fdc95b578b22d65eb29993ddd41d584428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "189c9d870f19cd7216737ebd6e2db406bdaebb5c58291cfa39174d07bd8d310c"
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
