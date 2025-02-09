class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "0a76ede494e5c65ac3df95cf2388118ee1565896c74e4bc2c2739d7fa4687b9d"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8239a24df8d215fd969a89d92f47e364b69ad515f8e9ad6cb64993204e73625f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8239a24df8d215fd969a89d92f47e364b69ad515f8e9ad6cb64993204e73625f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8239a24df8d215fd969a89d92f47e364b69ad515f8e9ad6cb64993204e73625f"
    sha256 cellar: :any_skip_relocation, sonoma:        "93273ad5fc27ee2d7fbee0375845a3163864de962098db9b3cf39cf26dce95cf"
    sha256 cellar: :any_skip_relocation, ventura:       "93273ad5fc27ee2d7fbee0375845a3163864de962098db9b3cf39cf26dce95cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44fd39c8f7dd213ff4c62e9f5786c8f1104e059501f975d1accbf53ffce0c9f6"
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
