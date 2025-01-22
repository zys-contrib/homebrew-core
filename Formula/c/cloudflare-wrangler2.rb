class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.104.0.tgz"
  sha256 "f7df325bf33184ef2496d2a79b3eb96e6cc761a2098064a95c7f259395abc7ea"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aef31607a6f4604d8d214c37aaaef8540eb9beb5a4110bfdb817297d0defe59f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aef31607a6f4604d8d214c37aaaef8540eb9beb5a4110bfdb817297d0defe59f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aef31607a6f4604d8d214c37aaaef8540eb9beb5a4110bfdb817297d0defe59f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bb4a99be0d998cf5f6bfcc8c6abd46eb44b622a19b96f19ccc1ed49b8a9d809"
    sha256 cellar: :any_skip_relocation, ventura:       "9bb4a99be0d998cf5f6bfcc8c6abd46eb44b622a19b96f19ccc1ed49b8a9d809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30f371e1ebf8d2e7a1943c45dfe4e27071b6547a9b17c7559de5639274cdf00d"
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
