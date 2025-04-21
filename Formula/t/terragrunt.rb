class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.77.22.tar.gz"
  sha256 "a506d8d05d6eebf757b0c1c3c18c70ba665e465b4088d4b176e48f14b892fc0d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb899201319968f4100cfb4875373f1bd4c04a877e42577aac3db8e358a38bdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb899201319968f4100cfb4875373f1bd4c04a877e42577aac3db8e358a38bdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb899201319968f4100cfb4875373f1bd4c04a877e42577aac3db8e358a38bdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b63aaf57a88d488a87fc43a82a481087963f2afe6c7e0eab21093da3825dcfe7"
    sha256 cellar: :any_skip_relocation, ventura:       "b63aaf57a88d488a87fc43a82a481087963f2afe6c7e0eab21093da3825dcfe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0bfddaa1257ec559759a56e713f805a786af6b3972eb06ed9e1b33e66f2514d"
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
