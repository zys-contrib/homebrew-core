class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/v0.14.10.tar.gz"
  sha256 "fa54c1ae94d54c45bee3a659633dcee5d8515f91611ea4fb853352f1d0fcb52a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1832b3ac46749a1c0549e6155ee0547a0ad7fcc9032daba525b808d9681fe19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1832b3ac46749a1c0549e6155ee0547a0ad7fcc9032daba525b808d9681fe19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1832b3ac46749a1c0549e6155ee0547a0ad7fcc9032daba525b808d9681fe19"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1832b3ac46749a1c0549e6155ee0547a0ad7fcc9032daba525b808d9681fe19"
    sha256 cellar: :any_skip_relocation, ventura:       "a1832b3ac46749a1c0549e6155ee0547a0ad7fcc9032daba525b808d9681fe19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "673c305addfb1140823e0af3958430e981a64234951b2de15c4a72ef07744519"
  end

  depends_on "pnpm@9" => :build
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
