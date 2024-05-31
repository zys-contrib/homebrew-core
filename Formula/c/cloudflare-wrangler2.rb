require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.58.0.tgz"
  sha256 "b997e0e0114667098d8b1bc53df8334ce94a90601db6c90bebf6b3a92654e32f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e45592f63e578672247e443ebddb5188d2237884bb946927c199a8e6ddc66af8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e45592f63e578672247e443ebddb5188d2237884bb946927c199a8e6ddc66af8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e45592f63e578672247e443ebddb5188d2237884bb946927c199a8e6ddc66af8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e553f3eacada77597f0dbd15ff88a9c40b98e6555d020a00e5eae9063009993"
    sha256 cellar: :any_skip_relocation, ventura:        "3e553f3eacada77597f0dbd15ff88a9c40b98e6555d020a00e5eae9063009993"
    sha256 cellar: :any_skip_relocation, monterey:       "3e553f3eacada77597f0dbd15ff88a9c40b98e6555d020a00e5eae9063009993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75d0b3c59b4a6ec277390a13da773dbe0e7c0ca93d474ab6e26f8deb5057657a"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}/lib/node_modules/**/*"]
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
