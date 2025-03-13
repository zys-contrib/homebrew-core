class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.8.tar.gz"
  sha256 "3d1ff8a58cafa3697453acb3e9bc52631f785d9f913e1afd14dcf6f6539f2bb1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83d81f2b53c204e606713478d7d7938dd0a9df1b9a1116f5e4869b50c844a7df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26e7f074c075cc85f18fbac8ff74352239a99e010496311c6252ed81b8f09daa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "429406408835547a79f3577ada16bd5742176dede83970946d9969981e7a7fb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b02bbdca5b845487e750480cbe29002cff014b2dc01532368401929bcde37ea"
    sha256 cellar: :any_skip_relocation, ventura:       "6a5c356734e470b7d200ad62641e5deaab928a12ac9af5419a03a833d6ab21fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d063c98533fca1490cb6331a757a9c106db52c2af486bd8e88fbfb6efa2e66ba"
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
