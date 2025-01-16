class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://docs.styra.com/regal"
  url "https://github.com/StyraInc/regal/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "41627aa17f2f7954f6ee684a0d688479d034bed03a46df6f977cb57e1f6bbfd8"
  license "Apache-2.0"
  head "https://github.com/StyraInc/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "452f4b4178309fa8bff16289d922663f6b256ad69437adfb83ebf95b509b0e38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "452f4b4178309fa8bff16289d922663f6b256ad69437adfb83ebf95b509b0e38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "452f4b4178309fa8bff16289d922663f6b256ad69437adfb83ebf95b509b0e38"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e00044f776462d7263b66e7434fcd38daca6bc945fbd6620ed626e359ab04cb"
    sha256 cellar: :any_skip_relocation, ventura:       "4e00044f776462d7263b66e7434fcd38daca6bc945fbd6620ed626e359ab04cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "317e60f09a2c9cf922b7170bfd267ad500fee47e60c3e7023562f838eac8a625"
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
