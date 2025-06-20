class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.20.5.tgz"
  sha256 "d42526188dd6170953bcaca114cefc29033bde10e6bb2596c63e9ad5234f08ce"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fa44ec7445ce18eb341336948a67e2135e1f23da7bc80dc408ea5bc6a344b32c"
    sha256 cellar: :any,                 arm64_sonoma:  "fa44ec7445ce18eb341336948a67e2135e1f23da7bc80dc408ea5bc6a344b32c"
    sha256 cellar: :any,                 arm64_ventura: "fa44ec7445ce18eb341336948a67e2135e1f23da7bc80dc408ea5bc6a344b32c"
    sha256                               sonoma:        "acc57aeb126e35357390b7ebced46345a793eacb4822ec94852dd3473d5fa1d1"
    sha256                               ventura:       "acc57aeb126e35357390b7ebced46345a793eacb4822ec94852dd3473d5fa1d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb9f9e8220f39a89251ea2919445119288a4209a4472e095229b995384174048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1456e232549f9c4f956ab638ccca669b711b1b1d00c2ea73b8ee0b7417df178"
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
