class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.101.0.tgz"
  sha256 "b22f7ba1f033f873285adc275f06637d152233a046111d9244aab9c27666fd8b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69dc856203953604f66a8da1b0a62a8609be85eab0fbe626394bb619136183ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69dc856203953604f66a8da1b0a62a8609be85eab0fbe626394bb619136183ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69dc856203953604f66a8da1b0a62a8609be85eab0fbe626394bb619136183ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dc236bff5773e5f4f6c7f6cacf4d50df38ad0d0da2cbd6a959edf12250c649d"
    sha256 cellar: :any_skip_relocation, ventura:       "8dc236bff5773e5f4f6c7f6cacf4d50df38ad0d0da2cbd6a959edf12250c649d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec225c3c7972f0ce0a9794fec9bb5a682bcc7b467a8d7fc6df37b2fcc03e1b72"
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
