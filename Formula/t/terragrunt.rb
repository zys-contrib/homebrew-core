class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.81.4.tar.gz"
  sha256 "50d0de75ee85c193b8ac113454143586aea36e087de28634a53c9f7f22f68fff"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9a2b122076200ee36cfae4333fc4a3d828ac7cb536f24e9e787061d24c6907d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9a2b122076200ee36cfae4333fc4a3d828ac7cb536f24e9e787061d24c6907d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9a2b122076200ee36cfae4333fc4a3d828ac7cb536f24e9e787061d24c6907d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4ff882f788600195834da5162e293a785dacc58c65d1fff0fd43d8775d1a7ef"
    sha256 cellar: :any_skip_relocation, ventura:       "f4ff882f788600195834da5162e293a785dacc58c65d1fff0fd43d8775d1a7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b461d69e35c83aeca8a71fa306d1541827cd9e1f152110864f5875ca34b8ee5"
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
