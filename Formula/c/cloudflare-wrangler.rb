class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.112.0.tgz"
  sha256 "ffd40e80552dea8ff8516496a632d014b9d54562d81144e68da477b455f6a665"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e8ab8d40a26b15711c7c61bbbef894a5bfa6ea01834ed50be8f0bdc82492f190"
    sha256 cellar: :any,                 arm64_sonoma:  "e8ab8d40a26b15711c7c61bbbef894a5bfa6ea01834ed50be8f0bdc82492f190"
    sha256 cellar: :any,                 arm64_ventura: "e8ab8d40a26b15711c7c61bbbef894a5bfa6ea01834ed50be8f0bdc82492f190"
    sha256                               sonoma:        "9680383cf037e65a7c58fc66cec444d75a6043a8bfef3b684edb11e6e3080528"
    sha256                               ventura:       "9680383cf037e65a7c58fc66cec444d75a6043a8bfef3b684edb11e6e3080528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3392185b2722f1f42f71a7b383ee296fee27a7e9fa50eddc9ae7a7e3e0523dd9"
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
