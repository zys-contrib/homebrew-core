class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.110.0.tgz"
  sha256 "47708547de659aeaa3dbd83f98134a20f61e6271167524d2644f37af96e35d1d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f9459f6626a5c4c617d7431edeb6007533ffe8e083d38ad6fff652321eae53e"
    sha256 cellar: :any,                 arm64_sonoma:  "0f9459f6626a5c4c617d7431edeb6007533ffe8e083d38ad6fff652321eae53e"
    sha256 cellar: :any,                 arm64_ventura: "0f9459f6626a5c4c617d7431edeb6007533ffe8e083d38ad6fff652321eae53e"
    sha256                               sonoma:        "1a433c2be386536c304b442967e151a87bd43d99429a88c94225077de580d945"
    sha256                               ventura:       "1a433c2be386536c304b442967e151a87bd43d99429a88c94225077de580d945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deebffce38e302321522300e24e6fd648192945c0e0e6296f6de56628e3e34e7"
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
