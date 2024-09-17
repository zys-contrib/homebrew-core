class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.67.7.tar.gz"
  sha256 "5ea1a0d9e59cb3b195d9050e85d719d0658b72d1fa132af80f4a6c98bdcd0366"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9a4961e7ae181ebad31d2839555185087d094257a475f5ee8482edaa94e7b05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9a4961e7ae181ebad31d2839555185087d094257a475f5ee8482edaa94e7b05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9a4961e7ae181ebad31d2839555185087d094257a475f5ee8482edaa94e7b05"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ade8ed2a8202c83cf332dd5d075495cb0c6a643c4e3e2be14833d0947003c85"
    sha256 cellar: :any_skip_relocation, ventura:       "8ade8ed2a8202c83cf332dd5d075495cb0c6a643c4e3e2be14833d0947003c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58929058d9a41096ccc1742d59b2127fa1c498da6849e8e24c488258901e72a1"
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
