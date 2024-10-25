class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v3.2.7.tar.gz"
  sha256 "141e8cffdcc27476620da4ac9164ac8d5474d4cb644dc2131e53bd5e8effde51"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a6f80424c0cc0282e2d1b46c4486c5b810b717a0d3b67e85d725d2f7db37e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6f80424c0cc0282e2d1b46c4486c5b810b717a0d3b67e85d725d2f7db37e03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a6f80424c0cc0282e2d1b46c4486c5b810b717a0d3b67e85d725d2f7db37e03"
    sha256 cellar: :any_skip_relocation, sonoma:        "af1334db715e0e094d43198699bb85f595548390e6bf28af9eadc5d158bf0c80"
    sha256 cellar: :any_skip_relocation, ventura:       "af1334db715e0e094d43198699bb85f595548390e6bf28af9eadc5d158bf0c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b8ad9e21b67e41717db47bbe1988d14dcab3e4908bf52666a414a5d736a174"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
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
