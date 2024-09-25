class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.67.13.tar.gz"
  sha256 "7a4ccb5779e42b43882622b5a093a262e9f917c77706960f5437b8896c0f80bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87ba0a90de2d5a9936254234cdf7b21b3492e646a00dd0f707cf0848be37c19f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ba0a90de2d5a9936254234cdf7b21b3492e646a00dd0f707cf0848be37c19f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87ba0a90de2d5a9936254234cdf7b21b3492e646a00dd0f707cf0848be37c19f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c484cd758ef72006dc68991175d5602ca36439c1fe204098ccb738edd2b420c"
    sha256 cellar: :any_skip_relocation, ventura:       "5c484cd758ef72006dc68991175d5602ca36439c1fe204098ccb738edd2b420c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e78a7c2f82160bd8fbe599611e02756b7d561b635c085cd894ae48dba68cfff"
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
