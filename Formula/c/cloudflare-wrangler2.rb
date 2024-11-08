class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.86.0.tgz"
  sha256 "217f58dd79f669aeede52d4aea2829d7bbd13665c7fb49f77e77ad035787ff3c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cb89f1d0d3ded355467b1e399af49f4d83f610b7280cd7613a2534eea1b3262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cb89f1d0d3ded355467b1e399af49f4d83f610b7280cd7613a2534eea1b3262"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cb89f1d0d3ded355467b1e399af49f4d83f610b7280cd7613a2534eea1b3262"
    sha256 cellar: :any_skip_relocation, sonoma:        "55231845adad2bc3a2f95c171cdd5ee988030ccdec9ba07ae317be0949010031"
    sha256 cellar: :any_skip_relocation, ventura:       "55231845adad2bc3a2f95c171cdd5ee988030ccdec9ba07ae317be0949010031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd59794fdd8c1c9a2b4dc16b8eddbab686233a6fa765dbb564b31749f6eac25"
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
