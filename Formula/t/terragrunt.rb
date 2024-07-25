class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.63.8.tar.gz"
  sha256 "9a3d557dc552f7411e427e75c84e9058c418cc31961f977161a2174a3d4fb495"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cb00e032a1b42a26e5a55b02c55952069ae11cf06905311ea0bba04a1276f30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "955b71ce8039cb8ae4d159fe9cf124f85a7b15179fb76cfe8dcc4398ca39e48d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78abdefaedd423c5583ed6084dc7411b3c28bd5cfebe291fad5f42e58597ea20"
    sha256 cellar: :any_skip_relocation, sonoma:         "332efcf50dc7b60bac5d345f3fc40f72e3751ecd83aa785fc7783f7dcc6f47f7"
    sha256 cellar: :any_skip_relocation, ventura:        "714d9fcf3101ab05124688a7717cf0092a6ce977e60b13d44b1560429347debf"
    sha256 cellar: :any_skip_relocation, monterey:       "84cbdee6079715246c51df07282374fb3742e1c3baf3cacc60bb7098f98543f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa4741349340cbfb0ea9bb1df12d4a5f425163aaedd2a0f180dbcef63b9b014e"
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
