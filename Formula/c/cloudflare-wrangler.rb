class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.7.2.tgz"
  sha256 "5da57eeb568f98eee40c68334de1ee9060206590b44bedab204cdbe2749f901b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c7d09e97febbf964c9d1f7bbeacba6ef2f003d616cceaa692ac7b4d344f54c47"
    sha256 cellar: :any,                 arm64_sonoma:  "c7d09e97febbf964c9d1f7bbeacba6ef2f003d616cceaa692ac7b4d344f54c47"
    sha256 cellar: :any,                 arm64_ventura: "c7d09e97febbf964c9d1f7bbeacba6ef2f003d616cceaa692ac7b4d344f54c47"
    sha256                               sonoma:        "f242e1e6146ef7f1a6348dfd9c3f41004425d5e38f984f535e941deda69d827d"
    sha256                               ventura:       "f242e1e6146ef7f1a6348dfd9c3f41004425d5e38f984f535e941deda69d827d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f80422b9af89ddca5dd5baa62d4e1f58d3b6736c11eeeef7d99a3af70556135c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "447299406bfb6d15f33e46b06b2444017796421a23e78a6e0007a8d2ba09dd11"
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
