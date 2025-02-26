class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.8.tar.gz"
  sha256 "c0446b820a73b2524de9242afb1369a58bbc8275a5798b94d29f3a5e0ad02dcf"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c68b1e9ff38725229e830d1d7bc268d11d20eff19460271ca92955bdf88ddcbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c68b1e9ff38725229e830d1d7bc268d11d20eff19460271ca92955bdf88ddcbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c68b1e9ff38725229e830d1d7bc268d11d20eff19460271ca92955bdf88ddcbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c68b1e9ff38725229e830d1d7bc268d11d20eff19460271ca92955bdf88ddcbf"
    sha256 cellar: :any_skip_relocation, ventura:       "c68b1e9ff38725229e830d1d7bc268d11d20eff19460271ca92955bdf88ddcbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "536e004ac72328a1654de652cda949c00073cbc1777e467def92e106a00830a9"
  end

  depends_on "pnpm" => :build
  depends_on "node"

  def install
    cd "packages/tailwindcss-language-server" do
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "run", "build"
      bin.install "bin/tailwindcss-language-server"
    end
  end

  test do
    require "open3"

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

    Open3.popen3(bin/"tailwindcss-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
