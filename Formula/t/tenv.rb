class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v3.2.8.tar.gz"
  sha256 "73e21934722a92449d3c1fef819cf9d92478b2470062f5c527b70b2535693a2a"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "589bcd8c368ee38d59e038fe441b52ce1182463b7f15fb1cbd09ee4860dc82ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "589bcd8c368ee38d59e038fe441b52ce1182463b7f15fb1cbd09ee4860dc82ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "589bcd8c368ee38d59e038fe441b52ce1182463b7f15fb1cbd09ee4860dc82ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "87bcce5e0ef92336a57fe28e839dd749505a6d457fe2ba6b4367bcca2b46568b"
    sha256 cellar: :any_skip_relocation, ventura:       "87bcce5e0ef92336a57fe28e839dd749505a6d457fe2ba6b4367bcca2b46568b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75a2a972d043c8d8e96e0272826cde2e92ad8a0c3f4ea49a989e091ea55b9327"
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
