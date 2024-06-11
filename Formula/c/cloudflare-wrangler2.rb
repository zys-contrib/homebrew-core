require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.60.2.tgz"
  sha256 "e752c1785a0f74488eb1f4ef7376b77d488c8e76aa0aaadfa925d7fff675eb84"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b527511f1748b716c7cdda4f825a78d9497050e4b04b802f4bdaa3c623350461"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b527511f1748b716c7cdda4f825a78d9497050e4b04b802f4bdaa3c623350461"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b527511f1748b716c7cdda4f825a78d9497050e4b04b802f4bdaa3c623350461"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ab5d6549da7a8f3e7742e861a21fc2016d27c899bda6efdfd60cdfd516a2fb2"
    sha256 cellar: :any_skip_relocation, ventura:        "9ab5d6549da7a8f3e7742e861a21fc2016d27c899bda6efdfd60cdfd516a2fb2"
    sha256 cellar: :any_skip_relocation, monterey:       "9ab5d6549da7a8f3e7742e861a21fc2016d27c899bda6efdfd60cdfd516a2fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0af142858c73a19c1ac09c66fc68dd62fea465fdb8b9ee946d584a7ca59145f"
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
