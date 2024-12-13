class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.69.13.tar.gz"
  sha256 "106c37ac50b8fc0ae0344fcf318c856c57b787fb98f81be9ef43bebd45ac72f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d92422001f6b09d64cbff92dda327c99f8b3cb0a8b70c1042228e1eca1095e9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d92422001f6b09d64cbff92dda327c99f8b3cb0a8b70c1042228e1eca1095e9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d92422001f6b09d64cbff92dda327c99f8b3cb0a8b70c1042228e1eca1095e9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "be1448d905e4a1170fa46e76fb83aa1a07e3b821a7454eee8b67f9cae44e6d39"
    sha256 cellar: :any_skip_relocation, ventura:       "be1448d905e4a1170fa46e76fb83aa1a07e3b821a7454eee8b67f9cae44e6d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e7ded5289fb4ee0b38804d4f9d48d5065b24ec426bfb7fb8a717aca8f4adce"
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
