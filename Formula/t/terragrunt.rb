class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.66.8.tar.gz"
  sha256 "c67e31f2be2bf5ce0a33744ebf963a07ff9b511d53fbcad488ff9107f364fbbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adb80b2219757b929c282dc6a15fdcc3d31ae5b10f67d0d111f79c27d76bcabe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32740d5c88440e4cae345dd8f487603fec9c9d8bf324c9c041c452ca85fa13d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ac18f7af196019ed95d4c793fd2e2ffddbd4d25f6eb2bb5587446bc3c134836"
    sha256 cellar: :any_skip_relocation, sonoma:         "13d31c4121854ab3ae1c9dba900791c70f9a19d5e55ad98f1b7fa9e48c5471c9"
    sha256 cellar: :any_skip_relocation, ventura:        "aecb4b7f45b5e611337e35bf0571c9cdaed4f68b3741809a2ac5591b76dd6a0a"
    sha256 cellar: :any_skip_relocation, monterey:       "b1cc17a78b27f550e877ff20475f413461549ed9c71bd0fe4ad20876f2a5d124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7baf13a8af2d303e5ddeb2975a5b260872ee23b8e70c9adb070dd1f348553fca"
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
