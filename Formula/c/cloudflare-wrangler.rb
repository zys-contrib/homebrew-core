class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.109.3.tgz"
  sha256 "02535baa568960201a7ce54b48a74abf65f16a2a1b674c2dc7147950182b8af2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7d04a809a1370cacb424d7f907ee29fe67e63bccc46a0c48f7f8d933fce1e72d"
    sha256 cellar: :any,                 arm64_sonoma:  "7d04a809a1370cacb424d7f907ee29fe67e63bccc46a0c48f7f8d933fce1e72d"
    sha256 cellar: :any,                 arm64_ventura: "7d04a809a1370cacb424d7f907ee29fe67e63bccc46a0c48f7f8d933fce1e72d"
    sha256                               sonoma:        "bd79cf3ab0f19928e8aa235a999514c2d06958d4f3548fc20afb0d0fc1e119de"
    sha256                               ventura:       "bd79cf3ab0f19928e8aa235a999514c2d06958d4f3548fc20afb0d0fc1e119de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5ce2aa870b22b5ba4f1f0130fffd7d7ac3e631d6e2b0d0155627b24384b6b7e"
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
