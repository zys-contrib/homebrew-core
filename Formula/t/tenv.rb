class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v1.11.16.tar.gz"
  sha256 "ae37854e1404038d150c12b81bffdf472166bccb901b28600a0ac29018db0c94"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75b2bef1186ec1eedf36f04c4d4d7c68aa4d77504fc01077b5f5de9b2f551e03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75b2bef1186ec1eedf36f04c4d4d7c68aa4d77504fc01077b5f5de9b2f551e03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75b2bef1186ec1eedf36f04c4d4d7c68aa4d77504fc01077b5f5de9b2f551e03"
    sha256 cellar: :any_skip_relocation, sonoma:         "fca7f811cda4382c7d07a889a37c4e7c2c3ccf3ed3f41b6915327ae07c5c423e"
    sha256 cellar: :any_skip_relocation, ventura:        "fca7f811cda4382c7d07a889a37c4e7c2c3ccf3ed3f41b6915327ae07c5c423e"
    sha256 cellar: :any_skip_relocation, monterey:       "fca7f811cda4382c7d07a889a37c4e7c2c3ccf3ed3f41b6915327ae07c5c423e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46ad1389e1440f3da457d6502250458004208e141e5c7386f9f1e51db4129504"
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
