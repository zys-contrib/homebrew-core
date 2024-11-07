class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.85.tar.gz"
  sha256 "5f544e08c18e20a82706a5a383e97278e96adfd6410b98defc68d74333be8cc2"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a645dc50f19a8fd409ba1a52db958d3310d10fef41d96163a4172151c5b9f8cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a645dc50f19a8fd409ba1a52db958d3310d10fef41d96163a4172151c5b9f8cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a645dc50f19a8fd409ba1a52db958d3310d10fef41d96163a4172151c5b9f8cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a8552583b4bfea73f69c07a06046afdd8057e26dfc8328dc983b386eac33405"
    sha256 cellar: :any_skip_relocation, ventura:       "0a8552583b4bfea73f69c07a06046afdd8057e26dfc8328dc983b386eac33405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30f3907ebe25df35784579e29c3f9f347b351df240b0ae3f27c52f0dedd528bd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "ERRO Unable to retrieve account id", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
