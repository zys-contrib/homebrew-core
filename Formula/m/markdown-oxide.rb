class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https://oxide.md"
  url "https://github.com/Feel-ix-343/markdown-oxide/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "ef7cef6461bcccdabeefb1150478a19091453a4477331e093bf7082f5dcd9588"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
    assert_match(/^Content-Length: \d+/i,
      pipe_output(bin/"markdown-oxide", "Content-Length: #{json.size}\r\n\r\n#{json}"))
  end
end
