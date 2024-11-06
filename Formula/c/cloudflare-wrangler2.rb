class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.85.0.tgz"
  sha256 "7f1a8437dab4819dfd8a444853fa6bdbe27f4b7ccea05f3f2a0be7a0da8ffcde"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d795f35b3aa5d148e4629beaa65717c4c7b6d693fcef344789cedea2db88e36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d795f35b3aa5d148e4629beaa65717c4c7b6d693fcef344789cedea2db88e36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d795f35b3aa5d148e4629beaa65717c4c7b6d693fcef344789cedea2db88e36"
    sha256 cellar: :any_skip_relocation, sonoma:        "7acf5b087dd90518a485c709f83e6c5ec2aa44b5e8705156c4cf8f477b4a4faa"
    sha256 cellar: :any_skip_relocation, ventura:       "7acf5b087dd90518a485c709f83e6c5ec2aa44b5e8705156c4cf8f477b4a4faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "311eb58a0972458dacb471812b183547d6d537672cfc533365949498a43aebdf"
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
