class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://github.com/Myriad-Dreamin/tinymist"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.12.8.tar.gz"
  sha256 "69755c0b6561d18517361a9d90c636ba95f18e32bb23cd752f5658657189c340"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa4894dcea6b25f19c6b8e8aac3bd5a770f63b5cdf478e3ebb4d7e862e8e7f91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "852b5c63588d9033e76baa08c47306f2393427ff24ffb6b6a7e3e9ed266a3c3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3b55631dc4dbf813f51bb0d0299e24fb6fe9ddd6dbcf200b2fadbd5369ce36b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7991c4efddbcc257f24406c9dbe412b89e0c91e1115498076521108aea72cadf"
    sha256 cellar: :any_skip_relocation, ventura:       "d133bb2ede1c77722c28034fd8e59126a19c33511b8c167badc4eb144ba5faee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e81308242e73c8e9e11ef71dd5e69881cd5e3cbf183676864f9474463d01e6ae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist")
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
    output = IO.popen(bin/"tinymist", "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(/^Content-Length: \d+/i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end
