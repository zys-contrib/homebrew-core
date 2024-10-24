class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v3.2.5.tar.gz"
  sha256 "7cd572ecdfa3903fc4f2848872be832144dd3412306c78d8dfeb7a322508bfcc"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dee75af08491ff73f024862d3dd012a3db5d5acaa072a30267dd200fc43a5bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dee75af08491ff73f024862d3dd012a3db5d5acaa072a30267dd200fc43a5bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dee75af08491ff73f024862d3dd012a3db5d5acaa072a30267dd200fc43a5bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d57c944b5cfa3e1aa2dac868c6a498d9fc482dbee865fbe643c8d44c729d2e93"
    sha256 cellar: :any_skip_relocation, ventura:       "d57c944b5cfa3e1aa2dac868c6a498d9fc482dbee865fbe643c8d44c729d2e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ea3b826c848ce94ac558dc2c063570df8fca9784fe2a1db60096dbefd1d0d43"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  # bump bubbletea to 1.1.2 to build with ansi 0.4.0, upstream pr ref, https://github.com/tofuutils/tenv/pull/268
  patch do
    url "https://github.com/tofuutils/tenv/commit/a5431705ce34bfbe3a12f6b069106025c6fd8cbd.patch?full_index=1"
    sha256 "f727a5ac69a438c76709491f2591f75fec1ceb1f9bde66654746e7d7b413eafa"
  end

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
