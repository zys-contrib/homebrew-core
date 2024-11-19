class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.68.17.tar.gz"
  sha256 "de77a52b90544f0f038239909661d46270977b0117c9700bd1eb6fa85049299c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce0254675a6bf91710e45e3220d1d4202fde69241897918731a03edd9d1c3b11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce0254675a6bf91710e45e3220d1d4202fde69241897918731a03edd9d1c3b11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce0254675a6bf91710e45e3220d1d4202fde69241897918731a03edd9d1c3b11"
    sha256 cellar: :any_skip_relocation, sonoma:        "eacec9a216896d20cfe4954f49ec653daa0cb4d7979d6e589ff9cc0a63e1d7d0"
    sha256 cellar: :any_skip_relocation, ventura:       "eacec9a216896d20cfe4954f49ec653daa0cb4d7979d6e589ff9cc0a63e1d7d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be6426b1f38b814ae00c3e5733a948742f516027c0517ae3e1cfb26e8cfe1bd"
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
