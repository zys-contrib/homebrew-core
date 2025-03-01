class Globstar < Formula
  desc "Static analysis toolkit for writing and running code checkers"
  homepage "https://globstar.dev"
  url "https://github.com/DeepSourceCorp/globstar/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "976aa520de6b3727f84f0a6e74efdd9baddc78d498f1953160c4fb1f7bfee2f2"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X globstar.dev/pkg/cli.version=#{version}"), "./cmd/globstar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/globstar --version")

    output = shell_output("#{bin}/globstar check 2>&1")
    assert_match "Checker directory .globstar does not exist", output
  end
end
