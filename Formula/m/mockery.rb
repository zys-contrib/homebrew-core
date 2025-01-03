class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.50.4.tar.gz"
  sha256 "b5ebe37c8185492e9f432f3fb7aaaa0ccdef90784fd4113eef14e3a6ec324c0c"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c458f4da205af8dd1a8ebe9f42d84d336bf1d61ae41e24b0f47eb810dc4a257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c458f4da205af8dd1a8ebe9f42d84d336bf1d61ae41e24b0f47eb810dc4a257"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c458f4da205af8dd1a8ebe9f42d84d336bf1d61ae41e24b0f47eb810dc4a257"
    sha256 cellar: :any_skip_relocation, sonoma:        "d158a8c7bfdce2b80dc535cc535bb6bd6f26cc230a13545941281440e0a4c75a"
    sha256 cellar: :any_skip_relocation, ventura:       "d158a8c7bfdce2b80dc535cc535bb6bd6f26cc230a13545941281440e0a4c75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b140d5417c3c47408561f5bac02b74a8c76fcf672cbed318535d28aadb85c4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
