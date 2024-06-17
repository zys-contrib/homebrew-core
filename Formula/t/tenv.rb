class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "59e30daba722a8a992b970520018f621f364f39222582890c2bcbae4e36c45ad"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b17af5636a3194fa0673268e2a3d9cb41a39f41f1730484ae68f4c72c9836d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b17af5636a3194fa0673268e2a3d9cb41a39f41f1730484ae68f4c72c9836d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b17af5636a3194fa0673268e2a3d9cb41a39f41f1730484ae68f4c72c9836d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6a2196af917efd8c659c1b9c41a0f733c34550ccf63dfe517d6239f7fbaa6d4"
    sha256 cellar: :any_skip_relocation, ventura:        "d6a2196af917efd8c659c1b9c41a0f733c34550ccf63dfe517d6239f7fbaa6d4"
    sha256 cellar: :any_skip_relocation, monterey:       "d6a2196af917efd8c659c1b9c41a0f733c34550ccf63dfe517d6239f7fbaa6d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d36d4af467876135223a33060c89143f3c1f5ab21c7ec4de72faef9298396b3"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
