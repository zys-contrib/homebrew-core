class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://github.com/Automattic/harper/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "bfc20385a67a1094221d2c34dd6895f9517e5037b814cc8749771d04be51f68e"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "766977016cd03322a0a355ca838585858ffae6533b54821134f077e08e3cc98c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "874c27777c7c695874ea876ed8730108a7b628a56cd890254d50d711e31f0c6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a673f40b3de830cc0cd85eaaeb2028c344643dbae14992a058dcb8113f93ae3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4391efd83f263b7015ca598d2488d1c8e7c7379e9b5d5798bd3256bd361a3384"
    sha256 cellar: :any_skip_relocation, ventura:       "ff2b5c26387dd345dc64035b0b453390e98127eefe062d593c4ed1e957137830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a58f03d149faaa06f092810af9e2ad6e54ac6b4d80129b07a327a2242169aac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc275879acaeca994648d01dfc7509f032c5967c720eca41e6de16cdaccd2b4c"
  end

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

    # Dialect in https://github.com/Automattic/harper/blob/833b212e8665567fa2912e6c07d7c83d394dd449/harper-core/src/word_metadata.rs#L357-L362
    system bin/"harper-cli", "lint", "--dialect", "American", "test.md"

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    assert_match "\"iteration\"", shell_output("#{bin}/harper-cli words")

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
