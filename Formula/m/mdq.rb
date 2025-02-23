class Mdq < Formula
  desc "Like jq but for Markdown"
  homepage "https://github.com/yshavit/mdq"
  url "https://github.com/yshavit/mdq/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "0a62a73f762e6ffa38dc914c585916d50d093c282a4805d6abd3cf1896a14293"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yshavit/mdq.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_file = testpath/"test.md"
    test_file.write <<~MARKDOWN
      # Sample Markdown

      ## Section 1

      - Item 1
      - Item 2

      ## Section 2

      - Item A
    MARKDOWN

    assert_equal <<~MARKDOWN, pipe_output("#{bin}/mdq '# Section 2'", test_file.read)
      ## Section 2

      - Item A
    MARKDOWN
  end
end
