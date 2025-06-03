class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.19.0.tgz"
  sha256 "f99b4621f2ca6bd16a15f3fc394a6bfe61e279edfd0a75d99d6dd26c64088931"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "319ad6a55407713240870396472ba34714226312757c8c16c9ac4f1c0ca5c8ea"
    sha256 cellar: :any,                 arm64_sonoma:  "319ad6a55407713240870396472ba34714226312757c8c16c9ac4f1c0ca5c8ea"
    sha256 cellar: :any,                 arm64_ventura: "319ad6a55407713240870396472ba34714226312757c8c16c9ac4f1c0ca5c8ea"
    sha256                               sonoma:        "2469fa6ab6af642d53f432eb12675fe018c4c2ab538c7e2314d24c6512d9c48f"
    sha256                               ventura:       "2469fa6ab6af642d53f432eb12675fe018c4c2ab538c7e2314d24c6512d9c48f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21015f451b97b2210a27098a6bf19335cd4ebaedc71108092bed57ec4a1a4558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35794551a8dab029eb346c63ce3fa7da3494f5d702d06917b38811c9b906bee0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
