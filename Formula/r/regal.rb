class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://docs.styra.com/regal"
  url "https://github.com/StyraInc/regal/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "49bfa9e94f66fffebe963c886686cdf7a202f7d4fbe6ed59b02d13e0bd0e3fc3"
  license "Apache-2.0"
  head "https://github.com/StyraInc/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f40d066d1136c4d555a369539dea11d26aea644fcb4945c574a912dae21c18e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ccc4c6641614266df53c10718324cb6f0e9aee100652652f45b00096ed9fe4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "364e05f0f042b4d3a7122f252d8baf7450b43465e82b86b90ee33b065e5db03c"
    sha256 cellar: :any_skip_relocation, sonoma:        "14a97802a0d7bdf4db8d51809862fbf94d3b7913e7fc83c1597c98db960be75a"
    sha256 cellar: :any_skip_relocation, ventura:       "a9f85edb7fa257198528cea76c25a56c943103e66c3fc74a64836410e81c344d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2368598797cecad6b2cac96f5681cfbda868e89109eb557fdfdf6255f586a5e5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/styrainc/regal/pkg/version.Version=#{version}
      -X github.com/styrainc/regal/pkg/version.Commit=#{tap.user}
      -X github.com/styrainc/regal/pkg/version.Timestamp=#{time.iso8601}
      -X github.com/styrainc/regal/pkg/version.Hostname=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"regal", "completion")
  end

  test do
    (testpath/"test").mkdir

    (testpath/"test/example.rego").write <<~REGO
      package test

      import rego.v1

      default allow := false
    REGO

    output = shell_output("#{bin}/regal lint test/example.rego 2>&1")
    assert_equal "1 file linted. No violations found.", output.chomp

    assert_match version.to_s, shell_output("#{bin}/regal version")
  end
end
