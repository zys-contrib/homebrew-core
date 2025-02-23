class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://github.com/Myriad-Dreamin/tinymist"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "19b880c12885ad4923238d5af261bd6f0e52f1851ce6fb3d5ee91ed473f8fd97"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "918f23ed033a41542a00934756d8bc16c30e84fceef63251052e7de1fe5503ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7829a9a5d91ebabc12db3143e72ea40f61a377f7efb7aa70f6fd56e03a194376"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c559cead72b5369a431f2387fbce2df99bc05c081787bc7b42e37b79c72de04"
    sha256 cellar: :any_skip_relocation, sonoma:        "a81818885a97e16e1921accf71925966a6e2f343f078d5789a7ce4340ff9bf78"
    sha256 cellar: :any_skip_relocation, ventura:       "4d51f528da2036950a42e914be1a635475e23802cdfed5c574f59582473544c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4ba937caaad2d1afa0d0a7a6aaf4e18309dc4d00fd95285f017854507982faf"
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
