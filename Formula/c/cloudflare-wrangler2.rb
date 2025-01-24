class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.105.1.tgz"
  sha256 "97d1769d1106a1917a0da660408eac28f811f7420516690dcb2c98aea56dc013"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "577a2f3b161029915e6e17d9d82945e7c6e261eb3edd298899495c4f3589caad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "577a2f3b161029915e6e17d9d82945e7c6e261eb3edd298899495c4f3589caad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "577a2f3b161029915e6e17d9d82945e7c6e261eb3edd298899495c4f3589caad"
    sha256 cellar: :any_skip_relocation, sonoma:        "90d42df0de660b7484c9e98cf7f4ba412661661082ae02a59a1b20c87d87aa0f"
    sha256 cellar: :any_skip_relocation, ventura:       "90d42df0de660b7484c9e98cf7f4ba412661661082ae02a59a1b20c87d87aa0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f7330c69b791263aac94013c7f83e466b05e8ebc8ed58d5bdde7222d19508e6"
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
