class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "2d579d05d89fde9b2b8b4cf1b60d7604353455d66807c7f93eeff8d8584184f8"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14aef680607a4ecb2c276a3e791bbb5fbf40c5093ec995b239890db3a76d1d68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14aef680607a4ecb2c276a3e791bbb5fbf40c5093ec995b239890db3a76d1d68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14aef680607a4ecb2c276a3e791bbb5fbf40c5093ec995b239890db3a76d1d68"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d10eb4589629e3a8fbafcf49766c27b2e9c5f26d1aa88c16ea7f3013ab26bcb"
    sha256 cellar: :any_skip_relocation, ventura:        "0d10eb4589629e3a8fbafcf49766c27b2e9c5f26d1aa88c16ea7f3013ab26bcb"
    sha256 cellar: :any_skip_relocation, monterey:       "0d10eb4589629e3a8fbafcf49766c27b2e9c5f26d1aa88c16ea7f3013ab26bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51e63ac9f81acdaeadc690824a06c72f294f1f54886b79a38325530a54f63e5e"
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
