class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "55a52d25182e3998750ed4b7705dcbe49247774ed6ebc6a6c747eb1f900fad3a"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65243a86d8699a91418b3d3bcd3dd32796f1535698a95c41e440b1aec365c2ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65243a86d8699a91418b3d3bcd3dd32796f1535698a95c41e440b1aec365c2ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65243a86d8699a91418b3d3bcd3dd32796f1535698a95c41e440b1aec365c2ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "98c50c245a86af8acc26632bf961d93aa1adbebc68c08ee71d961b361b587a60"
    sha256 cellar: :any_skip_relocation, ventura:        "98c50c245a86af8acc26632bf961d93aa1adbebc68c08ee71d961b361b587a60"
    sha256 cellar: :any_skip_relocation, monterey:       "98c50c245a86af8acc26632bf961d93aa1adbebc68c08ee71d961b361b587a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be8c3a2a1841f6d9ef7a4bd60a8b878b14b442230a70207cfaf5e31a0e0115f"
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
