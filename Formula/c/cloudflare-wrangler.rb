class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.4.1.tgz"
  sha256 "4a407c69003e8e9227eb565d5076eb356731972d1ecf66565184b9e31922f774"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5f0b022cd683528efcae4d46560d77350518a01918f8278db16ec6db2dee5ebb"
    sha256 cellar: :any,                 arm64_sonoma:  "5f0b022cd683528efcae4d46560d77350518a01918f8278db16ec6db2dee5ebb"
    sha256 cellar: :any,                 arm64_ventura: "5f0b022cd683528efcae4d46560d77350518a01918f8278db16ec6db2dee5ebb"
    sha256                               sonoma:        "bdd2b3286f009cefdc16c5a48b01a539fe19da52bb31af16b0c145eb3f15e251"
    sha256                               ventura:       "bdd2b3286f009cefdc16c5a48b01a539fe19da52bb31af16b0c145eb3f15e251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "debe2bb1b307db3a4a345060bc5b6b8d4c9be8b57e58e146216148ae1139750a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b0c40472b89c0a3bd620dee44921c0f33e2cebec4fd98aca6ee301c3384565e"
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
