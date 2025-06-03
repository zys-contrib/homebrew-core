class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.19.1.tgz"
  sha256 "5dc471e59b6ed317f01a80aba632019d03b3ba0627d8a4e0f6d5a20523b0ccb9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "25e84bc15a917c6b796c9acb2fd2bb8bf59dc6507cbe147d54ca4ba98d9cb497"
    sha256 cellar: :any,                 arm64_sonoma:  "25e84bc15a917c6b796c9acb2fd2bb8bf59dc6507cbe147d54ca4ba98d9cb497"
    sha256 cellar: :any,                 arm64_ventura: "25e84bc15a917c6b796c9acb2fd2bb8bf59dc6507cbe147d54ca4ba98d9cb497"
    sha256                               sonoma:        "bb8ba54588954046816d232a455933dd4396f3f438e162601f349b48d2ca6725"
    sha256                               ventura:       "bb8ba54588954046816d232a455933dd4396f3f438e162601f349b48d2ca6725"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e09a1b809348d066b14551e957d417bce4ced1f6d5a727f1857eba43b6ea2d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "575767037c1ff5eee2bad4c034df77a858240c9a3d04ee5b11e5e983019efbe8"
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
