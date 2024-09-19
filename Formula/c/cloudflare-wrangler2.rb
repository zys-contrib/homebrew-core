class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.78.6.tgz"
  sha256 "b63a022173f423f54a340dc636bbfc36b82520eb7b109ce5f99e756d7777c0d5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7addc26b7779a74dfdb470f7fe02819e78e0df59a2dca0de210e2b2d3d9087f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7addc26b7779a74dfdb470f7fe02819e78e0df59a2dca0de210e2b2d3d9087f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7addc26b7779a74dfdb470f7fe02819e78e0df59a2dca0de210e2b2d3d9087f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b98d79e0ae38caee23f1ff314b7061f64641eeb30ca39bc580b8ade10a52549"
    sha256 cellar: :any_skip_relocation, ventura:       "0b98d79e0ae38caee23f1ff314b7061f64641eeb30ca39bc580b8ade10a52549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feeea04ed332ffef32c4cfb4482a2732dfcf1b150803305b1e2df08a00aa972d"
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
