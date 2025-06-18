class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.14.3.tgz"
  sha256 "403c0b277c400cc82abdf9d83381eafef9d2ee0a90ba8c7c7b7c714a820d2eba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa93a4d876de1b7bde8c45aeaf1159405e23deb2183db982a875b1cb1bc056d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa93a4d876de1b7bde8c45aeaf1159405e23deb2183db982a875b1cb1bc056d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa93a4d876de1b7bde8c45aeaf1159405e23deb2183db982a875b1cb1bc056d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad16f2437079a09ce26f0ef5cd39fc05f3dfc05f68e7449033154a1ce096f3f"
    sha256 cellar: :any_skip_relocation, ventura:       "8ad16f2437079a09ce26f0ef5cd39fc05f3dfc05f68e7449033154a1ce096f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa93a4d876de1b7bde8c45aeaf1159405e23deb2183db982a875b1cb1bc056d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa93a4d876de1b7bde8c45aeaf1159405e23deb2183db982a875b1cb1bc056d3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port
    ENV["CLIENT_PORT"] = port.to_s

    read, write = IO.pipe
    fork do
      exec bin/"mcp-inspector", out: write
    end
    sleep 3

    assert_match "Starting MCP inspector...", read.gets
  end
end
