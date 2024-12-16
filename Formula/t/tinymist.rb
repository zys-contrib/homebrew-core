class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://github.com/Myriad-Dreamin/tinymist"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.12.12.tar.gz"
  sha256 "f9cb474364d2f1e42a51a0c409b03e7f2482787f260d7a2ab6df71dce27b4d47"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8b3c0f39b0117cbabd03ad4fe2c26545dc17bc5064c5ac66c1456c717edbf6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52c023ffdff14f79d4f39e53db5cf295621ba13ccdf632b9e373b5d1fa627fcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bf3e035ce2253d3cb18c93e4f07e4fd2473cefc076dcd3a73e74bd9cbfa2290"
    sha256 cellar: :any_skip_relocation, sonoma:        "3043071ce48e9522b7871163885706f9dc185a769aa27871623cd72a45abdf7a"
    sha256 cellar: :any_skip_relocation, ventura:       "315491fc844a8722fdb12d78e55d380dc48dea338a2f5c041ec846407c26dfa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71bbffed3c18413e67d2c54e07fdb01dfab57763b2cfb6794dbfa0f9c942333e"
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
