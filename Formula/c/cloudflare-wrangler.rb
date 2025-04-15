class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.11.0.tgz"
  sha256 "5e1d977be5693a692f5c7d6438755a6bffbcb443eeea9982ef2854343c2f3127"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70f007544b8f4e6c9f7cc17e292b4d2e246973a1fe35a26e77adf1c7d27872c0"
    sha256 cellar: :any,                 arm64_sonoma:  "70f007544b8f4e6c9f7cc17e292b4d2e246973a1fe35a26e77adf1c7d27872c0"
    sha256 cellar: :any,                 arm64_ventura: "70f007544b8f4e6c9f7cc17e292b4d2e246973a1fe35a26e77adf1c7d27872c0"
    sha256                               sonoma:        "7f5b43cbd22feb806f1710d0fcf5b681e6f550cf326ac36ed2bd6cdd28e83a18"
    sha256                               ventura:       "7f5b43cbd22feb806f1710d0fcf5b681e6f550cf326ac36ed2bd6cdd28e83a18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbf19a2899e82f98961f4b8950a717611a58774afef3cf697d459c086fff5483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12428448f725fd75805bdf3f0cdf890e055f165041bfacd382663374d900ffa0"
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
