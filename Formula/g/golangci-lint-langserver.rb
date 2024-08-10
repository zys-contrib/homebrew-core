class GolangciLintLangserver < Formula
  desc "Language server for `golangci-lint`"
  homepage "https://github.com/nametake/golangci-lint-langserver"
  url "https://github.com/nametake/golangci-lint-langserver/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "ad7241d271b9b46b6fc784ab1d035c322bd6ae44938514d69f5ad516a1a9fbfd"
  license "MIT"
  head "https://github.com/nametake/golangci-lint-langserver.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output(bin/"golangci-lint-langserver", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
