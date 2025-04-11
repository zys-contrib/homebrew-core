class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.77.14.tar.gz"
  sha256 "2765b74ca22502182d3e7f6b4197d823b8627bc090733ab2507bdd15190a703c"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3faaf5e25dfab95710ed880426e3ba6e6c1acf2a73a1986db5ebf2bc56430649"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3faaf5e25dfab95710ed880426e3ba6e6c1acf2a73a1986db5ebf2bc56430649"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3faaf5e25dfab95710ed880426e3ba6e6c1acf2a73a1986db5ebf2bc56430649"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c1862861a2171f90bddb9c4b168ed6b9f810fb249913040900f2f3fc0ed0a6a"
    sha256 cellar: :any_skip_relocation, ventura:       "0c1862861a2171f90bddb9c4b168ed6b9f810fb249913040900f2f3fc0ed0a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f05da969b2663fbff1d44d78a1e84127e48418c65ac7708eb66e5aececf214"
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
