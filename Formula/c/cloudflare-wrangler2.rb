class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.105.0.tgz"
  sha256 "4e29db0145b288175390f7ccfcb85600ae7d6da9bdac180269afcfb90cf69aed"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eb4efd9e0d0f49c1bad03c0d0aa630ba27a3cfde4b9fb60a08b4b50d7697d4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eb4efd9e0d0f49c1bad03c0d0aa630ba27a3cfde4b9fb60a08b4b50d7697d4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2eb4efd9e0d0f49c1bad03c0d0aa630ba27a3cfde4b9fb60a08b4b50d7697d4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "33a0ed892ff08fc519b4229127ae919a4a9a108b5484bd22680e963af155040b"
    sha256 cellar: :any_skip_relocation, ventura:       "33a0ed892ff08fc519b4229127ae919a4a9a108b5484bd22680e963af155040b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ab9d98ec8e8aa8d9537f1e61455bc912f525700e0d9dc32c760ac47628392dd"
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
