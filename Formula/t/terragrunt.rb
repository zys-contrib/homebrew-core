class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.67.11.tar.gz"
  sha256 "de1626d8dec1687ed64c99bc7005bd2ed41c198841319517ae0ab40960b27295"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "609288c485ac39f4537e11d7c83e8457e343b1eb6fc8a49c89e837f3c6beb7a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "609288c485ac39f4537e11d7c83e8457e343b1eb6fc8a49c89e837f3c6beb7a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "609288c485ac39f4537e11d7c83e8457e343b1eb6fc8a49c89e837f3c6beb7a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a98a8ba854b9522d293d166e45adca6541c216cc0655a73f61d1c0081cba9431"
    sha256 cellar: :any_skip_relocation, ventura:       "a98a8ba854b9522d293d166e45adca6541c216cc0655a73f61d1c0081cba9431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "506fbbbb0496670d727b7367cf17231b8d75e3c06f8b845a844d49a390c39646"
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
