class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/elijah-potter/harper"
  url "https://github.com/elijah-potter/harper/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "af07f2a621b876cb77a4dfa376bdab0df2e1b0b210816bb26e73e56878367634"
  license "Apache-2.0"
  head "https://github.com/elijah-potter/harper.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "harper-cli")
    system "cargo", "install", *std_cargo_args(path: "harper-ls")
  end

  test do
    # test harper-cli
    (testpath/"test.md").write <<~MARKDOWN
      # Hello Harper

      This is an example to ensure language detection works properly.
    MARKDOWN

    system bin/"harper-cli", "lint", "test.md"

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    output = shell_output("#{bin}/harper-cli words")
    assert_equal "A", output.lines.first.chomp

    # test harper-ls
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
    output = pipe_output("#{bin}/harper-ls --stdio 2>&1", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
