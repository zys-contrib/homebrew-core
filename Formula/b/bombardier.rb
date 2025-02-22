class Bombardier < Formula
  desc "Cross-platform HTTP benchmarking tool"
  homepage "https://github.com/codesenberg/bombardier"
  url "https://github.com/codesenberg/bombardier/archive/refs/tags/v2.0.tar.gz"
  sha256 "7afdeee6d7b2601cdefcfe6f822fc13de11cfe97b6848154460e17c1b454e278"
  license "MIT"
  head "https://github.com/codesenberg/bombardier.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bombardier --version 2>&1")

    url = "https://example.com"
    output = shell_output("#{bin}/bombardier -c 1 -n 1 #{url}")
    assert_match "Bombarding #{url} with 1 request(s) using 1 connection(s)", output
  end
end
