class JqLsp < Formula
  desc "Jq language server"
  homepage "https://github.com/wader/jq-lsp"
  url "https://github.com/wader/jq-lsp/archive/refs/tags/v0.1.13.tar.gz"
  sha256 "badf5c72063ae3232bd18f938980308f77fe2b4c5f3b8db6fccb8ca6db523834"
  license "MIT"
  head "https://github.com/wader/jq-lsp.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jq-lsp --version")

    expected = JSON.parse(<<~JSON)
      {
        "message": null,
        "name": null
      }
    JSON
    query = ".[0] | {message: .test.message, name: .test.name}"

    assert_equal expected, JSON.parse(shell_output("#{bin}/jq-lsp --query '#{query}'"))
  end
end
