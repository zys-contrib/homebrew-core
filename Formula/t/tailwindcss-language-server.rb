class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server"
  url "https://registry.npmjs.org/@tailwindcss/language-server/-/language-server-0.0.27.tgz"
  sha256 "d3c5f6c11ffcd8c7dc79a4d9d2e6d41f7d121ffd1a1fbdef9abc8faadeabff87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "161f901f79ec9bcc961dc63243634c333a32f783cbe996eb846306eb0fe200bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "161f901f79ec9bcc961dc63243634c333a32f783cbe996eb846306eb0fe200bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "161f901f79ec9bcc961dc63243634c333a32f783cbe996eb846306eb0fe200bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "604e1efabdbe9b9d5abcc5f6a5566f939a684d66af41bb7361ba4e7069eef1c0"
    sha256 cellar: :any_skip_relocation, ventura:       "604e1efabdbe9b9d5abcc5f6a5566f939a684d66af41bb7361ba4e7069eef1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db26b38216814c794d140567f267766664add80c1112a3c9c0e3ce06f2500481"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    (libexec/"lib/node_modules/@tailwindcss/language-server/bin").glob("*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      if OS.mac? && f.universal?
        deuniversalize_machos f
      else
        rm f
      end
    end
    (libexec/"lib/node_modules/@tailwindcss/language-server/bin").glob("*.musl-*.node").map(&:unlink) if OS.linux?
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
