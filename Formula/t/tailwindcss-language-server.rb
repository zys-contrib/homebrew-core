class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://github.com/tailwindlabs/tailwindcss-intellisense/archive/refs/tags/@tailwindcss/language-server@v0.0.27.tar.gz"
  sha256 "128ac08f1e5fd02f023b07b675c7ab490f5a463ac552480048edf6357220e826"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@tailwindcss/language-server/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d949c179367bba3099db932a32049dfef834e77b8484c10f6b620ecadd2ca1b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d949c179367bba3099db932a32049dfef834e77b8484c10f6b620ecadd2ca1b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d949c179367bba3099db932a32049dfef834e77b8484c10f6b620ecadd2ca1b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "613776479bd1a49ca55769553852a133e69fec0d1d977bd62f0e396cac5754ea"
    sha256 cellar: :any_skip_relocation, ventura:       "613776479bd1a49ca55769553852a133e69fec0d1d977bd62f0e396cac5754ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9e3fe9f2283f71129fb5d715eaead6677ecf6ab9ded712eb69f3ceecbe300d9"
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
