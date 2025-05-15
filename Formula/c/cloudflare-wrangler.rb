class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.15.1.tgz"
  sha256 "154b2bb8337d22328de34b5cd038a6bc40e0e82bbee27d325a6ee5d441251492"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f69c6992f0a64c0ea8a58589b016daf48a1bfe3e227458726210479970131282"
    sha256 cellar: :any,                 arm64_sonoma:  "f69c6992f0a64c0ea8a58589b016daf48a1bfe3e227458726210479970131282"
    sha256 cellar: :any,                 arm64_ventura: "f69c6992f0a64c0ea8a58589b016daf48a1bfe3e227458726210479970131282"
    sha256                               sonoma:        "40180777914ca3dd19a3cd5bea5daf1c18cef2f534e1fb27740d0aa4f472ae6e"
    sha256                               ventura:       "40180777914ca3dd19a3cd5bea5daf1c18cef2f534e1fb27740d0aa4f472ae6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3876aa9f39dda22b27fdcfd310d04c102bbab756b47bb5ec7f3b76be3dca381e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93a511bb7e4a6f915326748742654a3d0bf2db61f887367367af34a5c7f4bdda"
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
