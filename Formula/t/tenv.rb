class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v1.11.8.tar.gz"
  sha256 "03093a23aad4022e36f8b9cf5facc8f7e1a769e94ee6602935d7ff65699b0ad2"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f2ad49a4f80d86d777216cb8295ffef2e97c782019d60d71f3f9d3dee52430e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f2ad49a4f80d86d777216cb8295ffef2e97c782019d60d71f3f9d3dee52430e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f2ad49a4f80d86d777216cb8295ffef2e97c782019d60d71f3f9d3dee52430e"
    sha256 cellar: :any_skip_relocation, sonoma:         "79cfe9ee071398e344cc79bf3592336616a81b8581e4a9fde6fdfb9c29ff0347"
    sha256 cellar: :any_skip_relocation, ventura:        "79cfe9ee071398e344cc79bf3592336616a81b8581e4a9fde6fdfb9c29ff0347"
    sha256 cellar: :any_skip_relocation, monterey:       "79cfe9ee071398e344cc79bf3592336616a81b8581e4a9fde6fdfb9c29ff0347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40dc493685bfe6aac9ce6c2630de859b6e1272c7587d3a7d8d42ccc59dc89fde"
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
