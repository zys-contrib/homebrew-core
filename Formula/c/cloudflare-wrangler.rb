class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.4.0.tgz"
  sha256 "82796f2da42d8a902caa5c9254ab2df86ad54600fb2052cbb930635a25f2a786"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e286ab2fb1f345d119963e1b6d9690c665a2c0d4ef6b35bfd5ec3bd6e8c419c1"
    sha256 cellar: :any,                 arm64_sonoma:  "e286ab2fb1f345d119963e1b6d9690c665a2c0d4ef6b35bfd5ec3bd6e8c419c1"
    sha256 cellar: :any,                 arm64_ventura: "e286ab2fb1f345d119963e1b6d9690c665a2c0d4ef6b35bfd5ec3bd6e8c419c1"
    sha256                               sonoma:        "124a524f503a7c6f2083bf5f240a349c22fe7cd0fb5a08d4498b799e40e4317d"
    sha256                               ventura:       "124a524f503a7c6f2083bf5f240a349c22fe7cd0fb5a08d4498b799e40e4317d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f96749cf7d8e15bbf1bb510e09ba461330c8af471e4720698ea6c726a7b76749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4190d05f3926ac4b153a42d026fd8f7400a876078c773582d05d4a45e3d0d47d"
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
