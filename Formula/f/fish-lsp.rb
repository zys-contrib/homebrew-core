class FishLsp < Formula
  desc "LSP implementation for the fish shell language"
  homepage "https://www.fish-lsp.dev"
  url "https://registry.npmjs.org/fish-lsp/-/fish-lsp-1.0.8-3.tgz"
  sha256 "54b36663eb1ae807969d30399189285cea578d8b65e8943705601a98c81ee4b6"
  license "MIT"
  head "https://github.com/ndonfris/fish-lsp.git", branch: "master"

  depends_on "fish" => [:build, :test]
  depends_on "node"

  def install
    ENV.append "CXXFLAGS", "-std=c++20"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    man1.install "docs/man/fish-lsp.1"
    generate_completions_from_executable(bin/"fish-lsp", "complete", shells: [:fish])

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/fish-lsp/node_modules/tree-sitter/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
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
    output = pipe_output("#{bin}/fish-lsp start", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
